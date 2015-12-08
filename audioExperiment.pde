import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener beatListener;
GridItem[][] grid;

int cellSize, rows, cols, hoverRadius, circleSize, beatIndicatorSize, defBeatIndicatorSize;
boolean mouseInteractivity = false;

void setup() {
    size(1280, 720, P3D);
    //size(640, 640, P3D);
    // fullScreen(P2D);
    smooth(8);

    cellSize = 8;
    rows = height / cellSize;
    cols = width / cellSize;

    hoverRadius = 240;
    circleSize = 4;
    defBeatIndicatorSize = width / 3;
    beatIndicatorSize = defBeatIndicatorSize;

    mouseInteractivity = false;

    minim = new Minim(this);

    // this loads a song from the data folder
    song = minim.loadFile("data/Down The Line (It Takes A Number).mp3");
    song.loop();

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(60);

    beatListener = new BeatListener(beat, song);

    grid = gridInit();
}

class BeatListener implements AudioListener {
    private BeatDetect beat;
    private AudioPlayer source;

    BeatListener(BeatDetect beat, AudioPlayer source) {
        this.source = source;
        this.source.addListener(this);
        this.beat = beat;
    }

    void samples(float[] samps) {
        beat.detect(source.mix);
    }

    void samples(float[] sampsL, float[] sampsR) {
        beat.detect(source.mix);
    }
}

class GridItem {
    // position of center
    float posX, posY;
    float originalPosX, originalPosY;
    float scaleFactor = 0;

    int size;
    color clr = #ffffff;

    GridItem(int posX, int posY) {
        this.posX = posX;
        this.posY = posY;

        originalPosX = posX;
        originalPosY = posY;
    }

    float getPosX() {
        return posX;
    }

    float getPosY() {
        return posY;
    }

    float getOriginalPosX() {
        return originalPosX;
    }

    float getOriginalPosY() {
        return originalPosY;
    }

    void setPosX(float posX) {
        this.posX = posX;
    }

    void setPosY(float posY) {
        this.posY = posY;
    }
}

GridItem[][] gridInit() {
    GridItem[][] grid = new GridItem[rows][cols];
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            grid[i][j] = new GridItem(j * cellSize + cellSize / 2, i * cellSize + cellSize / 2);
            // print("x:", i * cellSize / 2, " ");
            // println("y:", j * cellSize / 2, " ");
        }
    }
    return grid;
}

void gridDraw() {
  float posX, posY;

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            posX = grid[i][j].getPosX();
            posY = grid[i][j].getPosY();
            pushMatrix();
            fill(grid[i][j].clr);
            noStroke();
            // scale(grid[i][j].scaleFactor + 1);
            translate(0, 0, grid[i][j].scaleFactor * 200);
            // translate(grid[i][j].scaleFactor, grid[i][j].scaleFactor, 0);
            // rect(posX, posY, cellSize, cellSize);
            ellipse(posX, posY, circleSize, circleSize);
            popMatrix();

            grid[i][j].clr = #FFEFE5;
        }
    }
}

void gridDance() {
    float x, y;
    float distance, posX, posY, pomX, pomY;

 
    for(int i = 0; i < song.bufferSize() - 1; i++) {
        //stroke(255);

        x = float(i) / song.bufferSize() * cols;
        //println(i, song.bufferSize(), int(x), cols);
        y = (song.mix.get(i) + 1) / 2 * rows;
        //grid[int(y)][int(x)].clr = #DE9B9B;
        for (int k = 0; k < int(y); k++) {
          grid[k][int(x)].clr = #DE9B9B;
        }
    }
}

void mouseMoved() {
    if (mouseInteractivity) {
        float x, y;
        float posX, posY, distance;

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                posX = grid[i][j].getPosX();
                posY = grid[i][j].getPosY();

                x = posX - mouseX;
                y = posY - mouseY;

                distance = sqrt(pow(x, 2) + pow(y, 2));
                if (distance <= hoverRadius) {
                    // grid[i][j].clr = #ffffff;
                    grid[i][j].scaleFactor = 1 - distance / hoverRadius;
                }
                else {
                    // grid[i][j].clr = #dedede;
                    grid[i][j].scaleFactor = 0;
                }
            }
        }
        // println(grid[1][1].scaleFactor);
    }
}

void draw() {
    background(#FFEFE5);
    noStroke();
    // stroke(255);
    // strokeWeight(4);

    gridDance();
    gridDraw();
    
    //saveFrame("frames/####.tif");
}