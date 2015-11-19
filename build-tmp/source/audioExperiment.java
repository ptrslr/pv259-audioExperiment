import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class audioExperiment extends PApplet {








Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener beatListener;
GridItem[][] grid;

int cellSize, rows, cols;

class BeatListener implements AudioListener {
	private BeatDetect beat;
	private AudioPlayer source;

	BeatListener(BeatDetect beat, AudioPlayer source) {
		this.source = source;
		this.source.addListener(this);
		this.beat = beat;
	}

	public void samples(float[] samps) {
		beat.detect(source.mix);
	}

	public void samples(float[] sampsL, float[] sampsR) {
		beat.detect(source.mix);
	}
}

class GridItem {
	// position of center
	int posX, posY;

	int size;
	int clr = 0xffffffff;

	GridItem(int posX, int posY) {
		this.posX = posX;
		this.posY = posY;
	}

	public int getPosX() {
		return posX;
	}

	public int getPosY() {
		return posY;
	}

	public void setPosX(int posX) {
		this.posX = posX;
	}

	public void setPosY(int posY) {
		this.posY = posY;
	}
}

public GridItem[][] gridInit() {
	GridItem[][] grid = new GridItem[rows][cols];
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			grid[i][j] = new GridItem(i * cellSize + cellSize / 2, j * cellSize + cellSize / 2);
			print("x:", i * cellSize / 2, " ");
			println("y:", j * cellSize / 2, " ");
		}
	}
	return grid;
}

public void gridDraw() {
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			point(grid[i][j].getPosX(), grid[i][j].getPosY());
		}
	}
}

public void setup() {
	
	// fullScreen(P2D);
	

	cellSize = 32;
	rows = height / cellSize;
	cols = width / cellSize;


	minim = new Minim(this);

	// this loads a song from the data folder
	song = minim.loadFile("data/default.mp3");
	song.play();

	beat = new BeatDetect(song.bufferSize(), song.sampleRate());
	beat.setSensitivity(300);

	beatListener = new BeatListener(beat, song);

	grid = gridInit();
}

public void mouseDragged() {
	int x, y;
	int posX, posY;

  x = mouseX / cellSize;
  y = mouseY / cellSize;

  posX = grid[x][y].getPosX() + PApplet.parseInt(random(-10, 10));
  posY = grid[x][y].getPosY() + PApplet.parseInt(random(-10, 10));

  grid[x][y].setPosX(posX);
	grid[x][y].setPosY(posY);
}

public void draw() {
	background(180);
	stroke(255);
  strokeWeight(4);

	gridDraw();

	// we draw the waveform by connecting neighbor values with a line
	// we multiply each of the values by 50
	// because the values in the buffers are normalized
	// this means that they have values between -1 and 1.
	// If we don't scale them up our waveform
	// will look more or less like a straight line.
	// for (int i = 0; i < height / 50; i++) {
	//     for(int j = 0; j < song.bufferSize() - 1; j++) {
	//         line(j*width/song.bufferSize(), 50 + song.mix.get(j)*50 + i*100, j*width/song.bufferSize()+1, 50 + song.mix.get(j+1)*50 + i*100);
	//     }
	// }
}
    public void settings() { 	size(640, 640); 	smooth(8); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "audioExperiment" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
