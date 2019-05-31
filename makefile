docker-build:
	docker rmi -f go-code
	docker build --build-arg pass=password -t go-code .
docker-clean:
	docker kill $(docker ps -a -q)
docker-start:
	docker run -v c:/Users/go/src:/root/go/src -p 8443:8443 -dit --restart unless-stopped go-code
docker-run:
	docker run --rm -p 8443:8443 -it go-code bash
