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

int cellSize, rows, cols, hoverRadius, circleSize;

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
            grid[i][j] = new GridItem(i * cellSize + cellSize / 2, j * cellSize + cellSize / 2);
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
            ellipse(posX, posY, circleSize, circleSize);
        }
    }
}

void setup() {
    size(640, 640);
    // fullScreen(P2D);
    smooth(8);

    cellSize = 64;
    rows = height / cellSize;
    cols = width / cellSize;

    hoverRadius = 120;
    circleSize = 8;


    minim = new Minim(this);

    // this loads a song from the data folder
    song = minim.loadFile("data/default.mp3");
    song.play();

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(300);

    beatListener = new BeatListener(beat, song);

    grid = gridInit();
}

void mouseMoved() {
    int x, y;
    float posX, posY, newPosX, newPosY, originalPosX, originalPosY;
    float angle, faderX, faderY;

    x = mouseX / cellSize;
    y = mouseY / cellSize;

    originalPosX = grid[x][y].getOriginalPosX();
    originalPosY = grid[x][y].getOriginalPosY();

    faderX = ((float)(mouseX - originalPosX) / cellSize + 1);
    faderY = ((float)(mouseY - originalPosY) / cellSize + 1);
    println(faderX);

    // float circleX = width/2 + cos(angle*i)*300;
    // float circleY = height/2 + sin(angle*i)*300;

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            posX = grid[x][y].getPosX();
            posY = grid[x][y].getPosY();

            angle = atan2(posY, posX);

            newPosX = posX + 20;
            newPosY = posY + 20;

            posX = lerp(newPosX, originalPosX, faderX);
            posY = lerp(newPosY, originalPosY, faderY);

            grid[x][y].setPosX(posX);
            grid[x][y].setPosY(posY);
        }
    }
}

void draw() {
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
