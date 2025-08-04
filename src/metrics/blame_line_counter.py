import subprocess
from collections import defaultdict
import os
import csv
from datetime import datetime

# Thư mục hiện tại của script
current_dir = os.path.dirname(os.path.abspath(__file__))

# Đường dẫn output (có thể điều chỉnh nếu muốn đổi chỗ lưu)
output_path = os.path.join(current_dir, "line_contribution.csv")

# Lấy danh sách file được quản lý bởi git
files = subprocess.check_output(['git', 'ls-files'], text=True).splitlines()
authors = defaultdict(int)

for file in files:
    try:
        blame_output = subprocess.check_output(['git', 'blame', '--line-porcelain', file], text=True)
        for line in blame_output.splitlines():
            if line.startswith("author "):
                author = line[7:]
                authors[author] += 1
    except Exception as e:
        print(f"[WARNING] Skip file {file} due to error: {e}")

# Ghi kết quả ra file CSV
with open(output_path, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['Date', 'Author', 'Lines'])

    date = datetime.now().strftime("%Y-%m-%d")
    for author, count in sorted(authors.items(), key=lambda x: x[1], reverse=True):
        writer.writerow([date, author, count])

print(f"[INFO] Output written to {output_path}")
