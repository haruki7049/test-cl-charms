build:
	# Build with qlot
	qlot exec sbcl --eval "(progn (asdf:operate 'asdf:compile-op 'test-cl-charms) (quit))"
