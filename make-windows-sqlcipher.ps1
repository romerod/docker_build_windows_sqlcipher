docker build . -t builder

docker run --rm -it -v "$(Get-Location):/output:rw" builder:latest
