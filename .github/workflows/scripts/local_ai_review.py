from transformers import pipeline
import subprocess
import os

def get_code_diff():
    """
    現在のプルリクエストのコード差分を取得    
    """
    result = subprocess.run([
        'git', 'diff', 
        os.environ('BASE_SHA'),
        os.environ('HEAD_SHA')
    ], capture_output=True, text=True, check=False)
    return result.stdout

# 無料のコードレビューモデル使用
reviewer = pipeline("text-generation", model="microsoft/CodeBERT-base")
diff = get_code_diff()

review = reviewer(f"Review this code diff in Japanese: {diff[:1500]}")  # トークン制限に注意
print(review)
