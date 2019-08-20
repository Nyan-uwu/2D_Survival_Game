public static class App {
	static Vector Block_Size;
	static Vector Chunk_Size;
	static Vector World_Size;
	static int World_SeaLevel;
	static int Chunk_GroundLevel = 7;

	public static void init(
		Vector bs, Vector cs, Vector ws
	) {
		Block_Size = bs;
		Chunk_Size = cs;
		World_Size = ws;
		World_SeaLevel = floor(ws.y/2);
	}
}

void setup() {
	size(600, 600);

	// Init Global App Variables //
	Vector ws = new Vector(10, 10);
	Vector cs = new Vector(20, 20);
	Vector bs = new Vector(floor(width/cs.x), floor(height/cs.y));

	App.init(
		bs, cs, ws
	);

	Player = new Player(new Vector(2, 2));
	World  = new World();
}

void draw() {
	background(#87ceeb);

	// Renders Current Chunk;
	Player.render();
}

public class Player {

	Vector pos;
	Vector currentChunk = new Vector(2, App.World_SeaLevel);

	Colour skin = new Colour(128, 0, 128);

	Player(Vector pos) {
		this.pos = pos;
	}
	void render() {
		try {
			World.chunks[this.currentChunk.x][this.currentChunk.y].render();
		} catch (NullPointerException e) {
			println("Generating Chunk @ pos: " + this.currentChunk.x + ":" + this.currentChunk.y);
			World.chunks[this.currentChunk.x][this.currentChunk.y] = new Chunk(new Vector(this.currentChunk.x,this.currentChunk.y));
			World.chunks[this.currentChunk.x][this.currentChunk.y].generate();
			println("Chunk Generated  @ pos: " + this.currentChunk.x + ":" + this.currentChunk.y);
		}
		fill(this.skin.r, this.skin.g, this.skin.b, this.skin.a); stroke(0, 255); rectMode(CORNER);
		rect(this.pos.x*App.Block_Size.x, this.pos.y*App.Block_Size.y, App.Block_Size.x, App.Block_Size.y);
	}

} Player Player;

// World
public class World {
	Chunk[][] chunks;
	World() { this.chunks = new Chunk[App.World_Size.x][App.World_Size.y]; }
} World World;

// Chunk
public class Chunk {

	Block[][] blocks;
	Boolean created = false;

	Boolean hasEnemy = false;

	Vector pos;
	Chunk(Vector pos) { this.pos = pos; } // Used For Chunk Coords

	// Generate Chunk *Random*
	void generate() {
		this.blocks = new Block[App.Chunk_Size.x][App.Chunk_Size.y];
		// Fill All Blocks With An Air Block // For Chunks Above App.World_SeaLevel
		for (int i = 0; i < this.blocks.length; i++) { for (int j = 0; j < this.blocks[i].length; j++) {
			Vector bPos = new Vector(i, j);
			this.blocks[i][j] = new Block(0, bPos);
		} }

		// Anything ABove App.World_SeaLevel Should Be Just Air!
		if (Player.currentChunk.y <= App.World_SeaLevel) {
			// Grass Floor
			if (Player.currentChunk.y == App.World_SeaLevel) {
				int bypos = App.Chunk_GroundLevel;
				for (int i = 0; i < App.Chunk_Size.x; i++) {
					int randNum = floor(random(0, 3));
					bypos += randNum == 0 ? -1 :
							 randNum == 1 ?  0 :
							 randNum == 2 ?  1 : 0;
					if (bypos < 6) { bypos = 6; }
					if (bypos > 8) { bypos = 8; }

					this.blocks[i][bypos] = new Block(1, new Vector(i, bypos));
					for (int j = bypos+1; j < App.Chunk_Size.y; j++) {
						Vector bPos = new Vector(i, j);
						this.blocks[i][j] = new Block(2, bPos);
					}
				}
			}
		}
		this.created = true;
	}

	void render() {
		if (this.created) {
			for (Block[] barr : this.blocks) { for (Block b : barr) {
				b.render();
			} }
		}
		else { this.generate(); }
	}
}

// Block
public class Block {

	int id;
	String type;

	Boolean t; // Transparency // Fall Through //

	Vector pos;
	Colour c;

	Block(
		int id, Vector pos
	) {
		this.id = id;
		this.type = typeLookup[this.id];
		this.c = textureLookup[this.id];
		if (this.id == 0)
			{ this.t = true; }
		else
			{ this.t = false; }

		this.pos = pos;

		if (this.id != 0) {
			println("Block Created Id: " + this.id + " | Type: " + this.type);
			println("Position: " + this.pos.x + ":" + this.pos.y);
		}
	}

	void render() {
		fill(this.c.r, this.c.g, this.c.b, this.c.a); stroke(0, 255); rectMode(CORNER);
		rect(this.pos.x*App.Block_Size.x, this.pos.y*App.Block_Size.y, App.Block_Size.x, App.Block_Size.y);
	}

}

String[] typeLookup = {
	"air", "grass", "dirt"
};
Colour[] textureLookup = {
	new Colour(255, 0), new Colour(126, 200, 80), new Colour(155, 118, 83)
};
