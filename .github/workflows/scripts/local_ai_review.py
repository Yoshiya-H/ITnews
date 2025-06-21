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

review = reviewer(f"Review this code diff in Japanese: {diff[:1500]}")  # トークン制限に注意
print(review)
