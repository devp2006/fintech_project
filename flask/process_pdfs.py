import os
import numpy as np
from PyPDF2 import PdfReader
from sentence_transformers import SentenceTransformer
import faiss

model = SentenceTransformer("all-MiniLM-L6-v2")

def extract_text_from_pdf(pdf_path):
    """Extract text from a PDF file, ignoring encoding issues."""
    reader = PdfReader(pdf_path)
    text = ""
    for page in reader.pages:
        try:
            page_text = page.extract_text()
            if page_text:
                text += page_text
        except Exception as e:
            print(f"Error extracting text from page: {e}")
            continue
    return text

def split_text_into_chunks(text, max_chunk_size=512):
    """Split the text into manageable chunks."""
    lines = text.splitlines()
    chunks = []
    chunk = ""

    for line in lines:
        if len(chunk) + len(line) + 1 > max_chunk_size:
            chunks.append(chunk.strip())
            chunk = line
        else:
            chunk += " " + line
    if chunk:
        chunks.append(chunk.strip())
    return chunks

def process_multiple_pdfs(pdf_paths):
    """Process multiple PDFs and generate combined chunks and embeddings."""
    all_chunks = []
    for pdf_path in pdf_paths:
        text = extract_text_from_pdf(pdf_path)
        chunks = split_text_into_chunks(text)
        print(f"Extracted {len(chunks)} chunks from {pdf_path}")
        all_chunks.extend(chunks)

    embeddings = model.encode(all_chunks)
    print(f"Generated {len(embeddings)} embeddings.")
    return all_chunks, embeddings

def save_chunks_and_embeddings(chunks, embeddings, folder):
    """Save chunks and embeddings to files."""
    chunks_file = os.path.join(folder, "chunks.txt")
    embeddings_file = os.path.join(folder, "embeddings.npy")

    with open(chunks_file, "w", encoding="utf-8", errors="ignore") as f:
        for chunk in chunks:
            f.write(chunk + "\n")
    np.save(embeddings_file, embeddings)

    # Save embeddings to FAISS index
    dimension = embeddings.shape[1]
    index = faiss.IndexFlatL2(dimension)
    index.add(np.array(embeddings, dtype="float32"))
    faiss.write_index(index, os.path.join(folder, "faiss_index"))
