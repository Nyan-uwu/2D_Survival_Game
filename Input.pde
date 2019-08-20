void keyPressed() {
	switch(str(key).toLowerCase()) {
		case "a":
			Player.pos.x -= 1;
			if (Player.pos.x < 0) {
				Player.currentChunk.x -= 1;
				Player.pos.x = App.Chunk_Size.x-1;
			}
		break;
		case "d":
			Player.pos.x+=1;
			if (Player.pos.x >= App.Chunk_Size.x) {
				Player.currentChunk.x += 1;
				Player.pos.x = 0;
			}
		break;
	}
}