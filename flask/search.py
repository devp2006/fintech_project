import os
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer

# Initialize the SentenceTransformer model
model = SentenceTransformer("all-MiniLM-L6-v2")

def load_chunks_and_faiss(folder):
    """
    Load chunks from a text file and the FAISS index.
    Args:
        folder (str): Path to the folder containing chunks.txt and faiss_index.
    Returns:
        list: List of chunks (str).
        faiss.Index: Loaded FAISS index.
    """
    chunks_file = os.path.join(folder, "chunks.txt")
    embeddings_file = os.path.join(folder, "faiss_index")

    # Load chunks
    with open(chunks_file, "r", encoding="utf-8", errors="ignore") as f:
        chunks = [line.strip() for line in f.readlines()]

    # Load FAISS index
    index = faiss.read_index(embeddings_file)
    return chunks, index

def query_faiss(query, chunks, index, top_k=3, relevance_threshold=0.5):
    """
    Retrieve the most relevant chunks based on the query using FAISS.
    Args:
        query (str): User query.
        chunks (list): List of text chunks.
        index (faiss.Index): FAISS index to search.
        top_k (int): Number of top results to return.
        relevance_threshold (float): Maximum distance for a result to be considered relevant.
    Returns:
        list: List of dictionaries containing chunks and scores, or None if no results.
    """
    # Encode the query to generate embeddings
    query_embedding = model.encode([query])
    query_embedding = np.array(query_embedding, dtype="float32")

    print(f"Query embedding shape: {query_embedding.shape}")

    # Perform FAISS search
    distances, indices = index.search(query_embedding, top_k)

    print(f"Distances: {distances}")
    print(f"Indices: {indices}")

    # Collect results
    results = []
    for i, idx in enumerate(indices[0]):
        if idx < len(chunks) and distances[0][i] <= relevance_threshold:
            results.append({"chunk": chunks[idx], "score": float(distances[0][i])})
        else:
            print(f"Excluded idx {idx}: score {distances[0][i]} (Threshold: {relevance_threshold}, Total Chunks: {len(chunks)})")

    print(f"Query results: {results}")
    return results if results else None

if __name__ == "__main__":
    # Example usage
    folder_path = "embeddings/chunks.txt"  # Replace with the actual folder path
    query = " International Level "  # Replace with your test query

    # Load chunks and FAISS index
    chunks, index = load_chunks_and_faiss(folder_path)

    print(f"Loaded {len(chunks)} chunks.")
    print(f"FAISS index contains {index.ntotal} vectors.")

    # Perform a search
    top_results = query_faiss(query, chunks, index, top_k=3, relevance_threshold=1)

    if top_results:
        print("\nTop results:")
        for result in top_results:
            print(f"Chunk: {result['chunk']}, Score: {result['score']}")
    else:
        print("No relevant results found.")
