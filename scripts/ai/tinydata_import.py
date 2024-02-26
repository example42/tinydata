from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.llms import OpenAI
import openai
import tinydata_functions

git_dir = tinydata_functions.get_git_base_dir()
files = tinydata_functions.get_files_in_directory("#{git_dir}/data")
vectordb_path = "#{git_dir}/chroma_db"

docs = []
for file in files:
    docs.extend(file.load())
#split text to chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
docs = text_splitter.split_documents(docs)
embedding_function = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2", model_kwargs={'device': 'cpu'})
#print(len(docs))

vectorstore = Chroma.from_documents(docs, embedding_function, persist_directory=vectordb_path)

print(vectorstore._collection.count())