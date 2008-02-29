ERL=erl

all:
	$(ERL) -make

run:
	$(ERL) -pa `pwd`/ebin
	
clean:
	rm -fv ebin/*.beam
	rm -fv erl_crash.dump