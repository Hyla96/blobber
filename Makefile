gen:
	protoc --proto_path=protos/src --dart_out=grpc:blobber_client/lib/gen/ -Iprotos protos/src/game.proto && \
	protoc --proto_path=protos/src --dart_out=grpc:blobber_server/lib/gen/ -Iprotos protos/src/game.proto
