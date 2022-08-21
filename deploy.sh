# Config file won't be applied unless config files are changes, but if we update the Dockerfile and build every tag as latest tag, config file won't see any difference and won't apply the new docker image
# To solve that we have to add the new version to the tag everytime we build the image and set that tag imperatively through the "kubectl set image" command after every push
# Therefore to do the automatic tag version without updating the script everytime, we will use the $GIT_SHA, SHA of the current commit, which is unique for each commit
# We tag the image with both latest and $GIT_SHA, so latest is always in same page with the current commit
docker build -t mahtovivek741/multi-client:latest -t mahtovivek741/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mahtovivek741/multi-server:latest -t mahtovivek741/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t mahtovivek741/multi-worker:latest -t mahtovivek741/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push mahtovivek741/multi-client:latest
docker push mahtovivek741/multi-client:$SHA
docker push mahtovivek741/multi-server:latest
docker push mahtovivek741/multi-server:$SHA
docker push mahtovivek741/multi-worker:latest
docker push mahtovivek741/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=mahtovivek741/multi-server:$SHA
kubectl set image deployments/client-deployment client=mahtovivek741/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mahtovivek741/multi-worker:$SHA