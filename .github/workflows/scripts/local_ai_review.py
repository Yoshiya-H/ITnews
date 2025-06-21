import subprocess
import os
from transformers import pipeline

def get_code_diff():
    """
    現在のプルリクエストのコード差分を取得    
    """
    result = subprocess.run([
        'git', 'diff', 
        os.environ['BASE_SHA'],
        os.environ['HEAD_SHA']
    ], capture_output=True, text=True, check=False)
    return result.stdout

reviewer = pipeline("text-generation", model="Salesforce/codegen-350M-mono")
diff = get_code_diff()
print(os.environ['BASE_SHA'])
print(os.environ['HEAD_SHA'])
print(f'diff: {diff}')

# トークン制限に注意
review_prompt = reviewer(f"Review this code diff in Japanese: {diff[:1000]}")
review = reviewer(review_prompt, max_new_tokens=300, do_sample=True, temperature=0.7)
print(review[0]['generated_text'])
