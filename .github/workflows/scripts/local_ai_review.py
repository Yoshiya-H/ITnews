import os
import sys
# import json
import requests
from openai import OpenAI

#diff = sys.argv[1]

AI_API_KEY = os.getenv("AI_API_KEY")
SYSTEM_PROMPT = ('You are a senior infrastracture engineer reviewing a git diff.\n'
                '- Write a Markdown-formatted code review summary that can be used as a commit comment.\n'
                '- Include sources in your review comments whenever possible.\n'
                '- Write in Japanese.\n'
                'The structure must include the following sections:\n\n'
                '1. **Overview**: A high-level summary of what was changed and why.\n\n'
                '2. **File-by-File Review**: For each file that has changes:\n'
                '    - Describe the purpose of the change.\n'
                '    - Provide review comments if needed.\n'
                '    - Use the following labels for each comment:\n'
                '        - **MUST**: Critical issues that must be fixed before merge.\n'
                '        - **IMPORTANT**: Non-blocking but important improvements or considerations.\n'
                '        - **NOTICE**: Optional suggestions or observations.\n\n'
                'Format each section clearly using Markdown syntax. Be concise but informative.\n'
                'Only output the Markdown — do not include any explanations outside of the formatted review.\n'
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
        ]
    )
    response_result = response.choices[0].message.content
    return response_result

if __name__ == "__main__":
    diff = get_pr_diff()
    print(get_ai_review(diff))

