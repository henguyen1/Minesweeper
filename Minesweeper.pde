

import de.bezier.guido.*;
int bombAmount = 0;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++)
    {
        for(int j = 0; j < NUM_COLS; j++)
        {
            buttons[i][j] = new MSButton(i,j);
        }
    }
    for(int a = 0; a < ((NUM_ROWS*NUM_COLS)/40); a++)
    {
        setBombs();
        bombAmount++;
    } 

}
public void setBombs() 
{
    int rRow = (int)(Math.random()*20);
    int rCol = (int)(Math.random()*20);
    if(!bombs.contains(buttons[rRow][rCol]))
    {
        bombs.add(buttons[rRow][rCol]);
    }
}
public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int countmarked = 0;
    int countclicks = 0;
    for(int rrow = 0; rrow < NUM_ROWS; rrow++)
    {
        for(int ccol = 0; ccol < NUM_COLS; ccol++)
        {
            if(buttons[rrow][ccol].isMarked()){countmarked++;}
            else if(buttons[rrow][ccol].isClicked()){countclicks++;}
        }
    }
    if(countmarked == bombAmount && (countmarked + countclicks)==NUM_ROWS*NUM_COLS && bombAmount == bombs.size())
    {
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    buttons[10][1].setLabel("Y");
    buttons[10][2].setLabel("o");
    buttons[10][3].setLabel("u");
    buttons[10][5].setLabel("L");
    buttons[10][6].setLabel("o");
    buttons[10][7].setLabel("s");
    buttons[10][8].setLabel("e");
    buttons[10][9].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[10][1].setLabel("Y");
    buttons[10][2].setLabel("o");
    buttons[10][3].setLabel("u");
    buttons[10][5].setLabel("W");
    buttons[10][6].setLabel("i");
    buttons[10][7].setLabel("n");
    buttons[10][8].setLabel("!");
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton==RIGHT)
        {
            if(marked==true)
            {
                marked = false;
                clicked = false;
            }
            else if(marked == false)
            {
                marked = true;
                clicked = false;
            }
        }
        if(mouseButton==LEFT)
        {
            if(bombs.contains(this))
            {
                displayLosingMessage();
            }
            else if((countBombs(r,c))>0)
            {
                setLabel(""+countBombs(r,c));
            }
            else
            {
                for(int row = r-1; row <= r+1;row++)
                {
                    for(int col = c-1; col <= c+1;col++)
                    {
                        if(isValid(row,col) && buttons[row][col].isClicked() == false)
                        {
                            buttons[row][col].mousePressed();
                        }
                    }
                }
            }
        }     
    }

    public void draw () 
    {    
        if (marked)
            fill(0,255,0);
        else if( clicked && bombs.contains(this) ) 
        {
            fill(255,0,0);
        }
        
        else if(clicked)
            fill(21, 97, 219);
        else 
            fill( 50 );

        rect(x, y, width, height,20);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < NUM_ROWS && r >= 0 && c < NUM_ROWS && c >= 0)
        {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int trow = r-1; trow <= r+1;trow++)
        {
            for(int tcol = c-1; tcol <= c+1;tcol++)
            {
                if(isValid(trow,tcol)==true&&bombs.contains(buttons[trow][tcol]))
                {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}



