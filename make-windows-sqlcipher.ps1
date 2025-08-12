docker build . -t builder
docker run --rm -v "$(Get-Location):/output:rw" builder:latest
