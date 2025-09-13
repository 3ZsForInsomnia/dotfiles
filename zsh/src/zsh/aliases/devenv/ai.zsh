alias runVectorDb="docker run -v ./chroma-data:/data -p 8000:8000 chromadb/chroma"

# takes a list of filetypes and runs `vectorcode vectorise` on them
function vca() {
  filetypes=("$@")
  path="./**/*."

  for filetype in "${filetypes[@]}"; do
    echo "Vectorising $filetype files..."
    vectorcode vectorise "$path$filetype"
  done
}

alias vc="vectorcode"
