import os
import sys
import json
import requests
from openai import OpenAI

#diff = sys.argv[1]

AI_API_KEY = os.getenv("AI_API_KEY")
SYSTEM_PROMPT = ('You are a professional infrastructure engineer who is good at code reviews.\n\n'
              '- Please try to show the source whenever possible\n'
              '- Be sure to comment on areas for improvement.\n'
              '- Please make review comments in Japanese.\n'
              '- Please prefix your review comments with one of the following labels "MUST:","IMPORTNAT:","NOTICE:".\n'
              '  - MUST: must be modified\n'
              '  - IMPORTNAT: Reference\n'
              '  - NOTICE: Proposals that do not require modification\n'
              '- The following json format should be followed.\n'
              '{"files":[{"fileName":"<file_name>","reviews": [{"lineNumber":<line_number>,"reviewComment":"<review comment>"}]}]}\n'
              '- If there is no review comment, please answer {"files":[]}\n'
              )
USER_PROMPT = "Please review the following code differences.:\n\n"
MODEL= "gemini-1.5-flash"

GITHUB_TOKEN = os.getenv('GH_TOKEN')
REPOSITORY = os.getenv("REPOSITORY")
PR_NUMBER = int(os.getenv("PR_NUMBER"))
PR_API_URL = f'https://api.github.com/repos/{REPOSITORY}/pulls/{PR_NUMBER}'

def get_pr_diff():
    """PRの差分を取得"""
    url = f'{PR_API_URL}/files'
    headers = {
        'Authorization': f'token {GITHUB_TOKEN}',
        'Accept': 'application/vnd.github+json'
    }
    response = requests.get(url, headers=headers)
    pr_diff = response.json()
    return pr_diff

def get_ai_review(diff):
    """AIによるコードレビュー"""
    client = OpenAI(
        api_key=AI_API_KEY,
        base_url="https://generativelanguage.googleapis.com/v1beta/openai/"
    )

    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f'{USER_PROMPT}{diff}'}
        ],
        response_format={"type":"json_object"}
    )
    response_result = response.choices[0].message.content
    return response_result

def post_review_comments(review_result):
    """レビュー結果をコメント投稿"""
    print(f'review_result:\n{review_result}')
    url = f'{PR_API_URL}/commits'
    headers = {
        'Authorization': f'token {GITHUB_TOKEN}',
        'Accept': 'application/vnd.github+json'
    }
    pr_commits_response = requests.get(url, headers=headers)
    pr_commits = pr_commits_response.json()
    last_commit = pr_commits[-1]['sha']
    for file in review_result["files"]:
        for review in file["reviews"]:
            comment_url = f'{PR_API_URL}/comments'
            comment_data = {
                'body': review["reviewComment"],
                'commit_id': last_commit,
                'path': file["fileName"],
                'position': review["lineNumber"]
            }
            requests.post(comment_url, headers=headers, data=json.dumps(comment_data))

if __name__ == "__main__":
    diff = get_pr_diff()
    review_result = get_ai_review(diff)
    post_review_comments(json.loads(review_result))
