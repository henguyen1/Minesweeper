

import de.bezier.guido.*;
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
    for(int a = 0; a < ((NUM_ROWS*NUM_COLS)/5); a++)
    {
        setBombs();
    } 

}
public void setBombs() // maybe use this function to help think of a way to do isWon()
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
    for(int a = 0; a < bombs.size();a++)
    {
        if(bombs.get(a).isClicked()==false  )
        {
            return true;
        }
    }
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
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
            fill(0);
        else if( clicked && bombs.contains(this) ) 
        {
            fill(255,0,0);
        }
        
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
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



