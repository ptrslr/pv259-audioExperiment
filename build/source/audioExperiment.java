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
Point[][] points;

float x1, x2, y1, y2, x3, y3, x4, y4;

int pointContainerSize, rows, cols;

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

class Point {
    // position of center
    int x, y;

    int size;
    int clr = 0xffffffff;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

public Point[][] pointsInit() {
    Point[][] points = new Point[rows][cols];
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            points[i][j] = new Point(j * pointContainerSize + pointContainerSize / 2, i * pointContainerSize + pointContainerSize / 2);
            print("x:", i * pointContainerSize / 2, " ");
            println("y:", j * pointContainerSize / 2, " ");
        }
    }
    return points;
}

public void pointsDraw() {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            point(points[i][j].x, points[i][j].y);
        }
    }
}

public void setup() {
    //size(640, 640);
    
    

    pointContainerSize = 32;
    rows = height / pointContainerSize;
    cols = width / pointContainerSize;


    minim = new Minim(this);

    // this loads mysong.wav from the data folder
    song = minim.loadFile("data/default.mp3");
    song.play();

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(300);

    beatListener = new BeatListener(beat, song);

    points = pointsInit();
}

public void draw() {
    background(0);
    stroke(255);

    pointsDraw();

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
    public void settings() {  fullScreen(P2D);  smooth(8); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "audioExperiment" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
