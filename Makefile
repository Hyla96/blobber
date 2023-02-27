gen:
	protoc --proto_path=protos/src --dart_out=blobber_client/lib/gen/ protos/src/game.proto && \
	protoc --proto_path=protos/src --dart_out=blobber_server/src/gen/ protos/src/game.proto
