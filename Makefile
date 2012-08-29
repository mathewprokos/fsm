all: main main.png

main.c:main.rl commands.h
	ragel -C main.rl -o main.c 

main:main.c
	gcc -o main main.c

main.dot:main.rl commands.h
	ragel -V main.rl -o main.dot

main.png:main.dot
	./fr.sh commands.h main.dot
	dot -Tpng main.dot > main.png

clean:
	rm main.c main main.dot main.png
