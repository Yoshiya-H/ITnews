import os
from transformers import pipeline


reviewer = pipeline("text-generation", model="Salesforce/codegen-350M-mono")
diff = os.environ['DIFF']
print(os.environ['BASE_SHA'])
print('->')
print(os.environ['HEAD_SHA'])
print(f'diff: {diff}')

# トークン制限に注意
review_prompt = reviewer(f"Review this code diff in Japanese: {diff[:1000]}")
review = reviewer(review_prompt, max_new_tokens=300, do_sample=True, temperature=0.7)
print(review[0]['generated_text'])
