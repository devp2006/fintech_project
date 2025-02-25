from flask import Flask, request, jsonify
from process_pdfs import process_multiple_pdfs, save_chunks_and_embeddings
from search import load_chunks_and_faiss, query_faiss
import os

app = Flask(__name__)

# Folder to save uploaded PDFs and embeddings
UPLOAD_FOLDER = "uploaded_pdfs"
EMBEDDINGS_FOLDER = "embeddings"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(EMBEDDINGS_FOLDER, exist_ok=True)

@app.route("/upload", methods=["POST"])
def upload_pdfs():
    """
    Endpoint to upload and process one or more PDFs.
    """
    if "files" not in request.files:
        return jsonify({"error": "No files uploaded"}), 400

    files = request.files.getlist("files")
    if not files:
        return jsonify({"error": "No files selected"}), 400

    file_paths = []
    for file in files:
        if file.filename == "":
            continue
        file_path = os.path.join(app.config["UPLOAD_FOLDER"], file.filename)
        file.save(file_path)
        file_paths.append(file_path)

    if not file_paths:
        return jsonify({"error": "No valid files uploaded"}), 400

    try:
        # Process the uploaded PDFs
        print(f"Processing PDFs: {file_paths}")
        chunks, embeddings = process_multiple_pdfs(file_paths)
        print(f"Extracted chunks: {chunks}")
        save_chunks_and_embeddings(chunks, embeddings, EMBEDDINGS_FOLDER)
        return jsonify({"message": "PDFs processed and knowledge base updated!"}), 200
    except Exception as e:
        print(f"Error during PDF processing: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.route("/query", methods=["POST"])
def query_knowledge_base():
    """
    Endpoint to query the knowledge base for an answer to a user-provided query.
    """
    data = request.json
    query = data.get("query")
    if not query or not query.strip():
        return jsonify({"error": "Query cannot be empty"}), 400

    try:
        # Load chunks and FAISS index
        print("Loading knowledge base...")
        chunks, index = load_chunks_and_faiss(EMBEDDINGS_FOLDER)
        print(f"Knowledge base loaded. Chunks: {len(chunks)}")

        # Find the most relevant answer
        results = query_faiss(query, chunks, index)
        print(f"Query: {query}")
        print(f"Results: {results}")

        if results:
            return jsonify({"results": results}), 200
        else:
            return jsonify({"message": "No relevant information found for your query."}), 200
    except Exception as e:
        print(f"Error during query processing: {str(e)}")
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
