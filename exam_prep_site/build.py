from pathlib import Path
import html
import shutil
import zipfile
from urllib.parse import quote

import mistune
import nbformat
from nbconvert import HTMLExporter

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT.parent / 'exam_prep'
OUTPUT = ROOT / 'public'
OUTPUT.mkdir(exist_ok=True)
(OUTPUT / 'files').mkdir(exist_ok=True)
(OUTPUT / 'notebooks').mkdir(exist_ok=True)

labs = [
    ('Lab1_EDA_pipeline.ipynb', 'Exploratory data analysis', 'Clean, explore, encode and scale your data.'),
    ('Lab2_MLR_scratch.ipynb', 'Multiple linear regression', 'Normal equation and gradient descent, from scratch.'),
    ('Lab3_DecisionTrees.ipynb', 'Decision trees', 'Entropy, Gini, classification and regression.'),
    ('Lab4_SVM.ipynb', 'Support vector machines', 'Compare kernels, boundaries and support vectors.'),
    ('Lab5_Regularization.ipynb', 'Regularization', 'Ridge, Lasso and ElasticNet for wine quality.'),
    ('Lab6_LogisticRegression_scratch.ipynb', 'Logistic regression', 'Sigmoid, gradients and classification metrics.'),
]
papers = [
    ('QP_A.R', 'QP A', 'Training hours vs productivity, and the normal distribution.'),
    ('QP_B.R', 'QP B', 'Multiple linear regression, and Poisson probabilities and simulation.'),
    ('QP_C.R', 'QP C', 'Social media hours vs exam score, and the binomial distribution with a Poisson approximation.'),
]
css = '''
:root{color-scheme:light;--ink:#172d2a;--muted:#52655f;--line:#d6ded6;--accent:#185947}
*{box-sizing:border-box}body{margin:0;background:#f5f5ed;color:var(--ink);font:16px/1.65 system-ui,sans-serif}
main{max-width:1100px;margin:auto;padding:64px 24px}a{color:var(--accent);text-underline-offset:4px}
a:focus-visible{outline:3px solid #b06122;outline-offset:5px}.eyebrow{font-size:12px;letter-spacing:.16em;text-transform:uppercase;font-weight:700}
h1{font-size:clamp(38px,7vw,76px);line-height:1.04;letter-spacing:-.055em;max-width:800px;margin:24px 0}
.intro{max-width:640px;color:var(--muted);font-size:19px}.button{display:inline-block;background:var(--accent);color:white;padding:12px 20px;border-radius:6px;text-decoration:none;font-weight:600}
.actions{display:flex;gap:22px;flex-wrap:wrap;align-items:center;margin:28px 0 48px}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
article{background:#fffef8;border:1px solid var(--line);border-radius:10px;padding:28px}article h2{font-size:23px;line-height:1.25;margin:12px 0}article p{color:var(--muted)}
.links{display:flex;gap:20px;flex-wrap:wrap;font-weight:600}.section{margin-top:48px;border-top:1px solid var(--line);padding-top:24px}
li{margin:10px 0}footer{margin-top:48px;color:var(--muted);font-size:14px}table{border-collapse:collapse;display:block;overflow:auto}td,th{padding:10px;border:1px solid var(--line);text-align:left}
pre{overflow:auto;padding:18px;background:#e9eee5;border-radius:6px}img{max-width:100%}.guide h1{font-size:42px}.guide h2{margin-top:36px}
@media(max-width:650px){main{padding:36px 18px}.grid{grid-template-columns:1fr}article{padding:22px}}
'''

def page(title, body):
    return f'<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{html.escape(title)}</title><style>{css}</style></head><body><main>{body}</main></body></html>'

files = sorted(p for p in SOURCE.iterdir() if p.is_file() and p.suffix in {'.ipynb', '.csv', '.xlsx', '.md', '.R'})
for file in files:
    shutil.copy2(file, OUTPUT / 'files' / file.name)
with zipfile.ZipFile(OUTPUT / 'exam_prep.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
    for file in files:
        archive.write(file, 'exam_prep/' + file.name)

exporter = HTMLExporter(template_name='lab')
cards = []
for i, (filename, title, description) in enumerate(labs, 1):
    notebook = nbformat.read(SOURCE / filename, as_version=4)
    rendered, _ = exporter.from_notebook_node(notebook)
    nav = '<nav style="padding:16px 24px;font:16px system-ui;background:#f5f5ed"><a href="../index.html">← All labs</a> · <a download href="../files/' + quote(filename) + '">Download notebook</a></nav>'
    rendered = rendered.replace('<body>', '<body>' + nav, 1)
    (OUTPUT / 'notebooks' / f'lab-{i}.html').write_text(rendered)
    cards.append(f'<article><span class="eyebrow">Lab {i:02}</span><h2>{title}</h2><p>{description}</p><div class="links"><a href="notebooks/lab-{i}.html">Read notebook →</a><a download href="files/{quote(filename)}">Download .ipynb</a></div></article>')

datasets = ''.join(f'<li><a download href="files/{quote(p.name)}">{html.escape(p.name)}</a></li>' for p in files if p.suffix in {'.csv', '.xlsx'})
paper_cards = ''.join(
    f'<article><h3>{title}</h3><p>{description}</p>'
    f'<a class="button" download="{filename}" href="files/{quote(filename)}">Download {title} (.R) ↓</a></article>'
    for filename, title, description in papers
)
body = '''<div class="eyebrow">Machine learning / Exam practice</div><h1>Six labs.<br>One place to revise.</h1>
<p class="intro">Read the code and saved outputs, then download the notebooks and practise in Jupyter or Colab.</p>
<div class="actions"><a class="button" download href="exam_prep.zip">Download all files ↓</a><a href="#r-question-papers">R question papers</a><a href="guide.html">Study guide</a><a href="https://github.com/ayoosh007/practice/tree/main/exam_prep">View on GitHub ↗</a></div>
<section class="section" id="r-question-papers" aria-labelledby="r-papers-title"><h2 id="r-papers-title">R question papers</h2>
<p>Download each paper as a separate R script. Each file includes both questions. Open it in RStudio or run it with Rscript.</p>
<p>QP B needs <code>scatterplot3d</code>. Install it once in R with <code>install.packages("scatterplot3d")</code>.</p>
<div class="grid">''' + paper_cards + '''</div></section>
<h2>Lab notebooks</h2>
<section class="grid" aria-label="Lab notebooks">''' + ''.join(cards) + '''</section>
<section class="section"><h2>Datasets</h2><p>Keep these files in the same folder as your notebooks.</p><ul>''' + datasets + '''</ul></section>
<footer>These pages show saved notebook outputs. Download a notebook to edit or run it. The complete ZIP also includes the original README and the Lab 1 copy.</footer>'''
(OUTPUT / 'index.html').write_text(page('ML lab exam practice', body))
guide = mistune.html((SOURCE / 'README.md').read_text())
for i, (filename, _, _) in enumerate(labs, 1):
    guide = guide.replace(f'href="{filename}"', f'href="notebooks/lab-{i}.html"')
guide = guide.replace('From the project root, using the existing environment:', 'After extracting the ZIP, install the packages listed below and run from the folder containing exam_prep:')
guide = guide.replace('.venv/bin/python -m jupyter', 'python -m jupyter')
(OUTPUT / 'guide.html').write_text(page('Study guide — ML lab exam practice', '<a href="index.html">← All labs</a><div class="guide">' + guide + '</div>'))
print(f'Built {len(labs)} notebook pages, {len(papers)} R paper downloads and {len(files)} total downloads in {OUTPUT}')
