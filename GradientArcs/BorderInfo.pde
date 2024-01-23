
class BorderInfo {

  boolean framing = false;      // toggle frame

  String headerText;
  String footerText = "Yo-Shi";

  color font_color = #77282828;

  boolean showText = true;

  int dpos;
  int inner_sizeX;
  int inner_sizeY;

  int canvasWidth;
  int canvasHeight;

  int randInit;

  private PFont headerFont;
  private PFont footerFont;

  private float headerFontSize;
  private float footerFontSize;

  public BorderInfo(int canvasWidth,
    int canvasHeight,
    int seed,
    float borderPercent) {

    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;

    randInit = seed;

    inner_sizeX = floor(canvasWidth * (1 - borderPercent));
    inner_sizeY = floor(canvasHeight * (1 - borderPercent));
    int inner_border = floor(border * canvasWidth);
    dpos = inner_border / 2;

    this.headerFontSize = dpos/3; //floor(width / 42);
    this.footerFontSize = dpos/3; // floor(width / 38);

    headerFont = createFont("Century Gothic", headerFontSize); // Moonbeam
    footerFont = createFont("Century Gothic", footerFontSize); // Moonbeam
  }

  public int getDisplacement()
  {
    return framing ? dpos : 0;
  }

  public int getInnerSizeX() {
  
     return framing ? inner_sizeX :  canvasWidth; 
  
  }

  public void setShowFraming(boolean enable) {

    framing = enable;
  }

  public boolean isShowFraming() {
    return framing;
  }

  public void drawCasing(PGraphics baselayer)
  {
    baselayer.beginDraw();
    baselayer.pushStyle();

    baselayer.noFill();
    baselayer.stroke(0xAA282828);
    baselayer.strokeWeight(0.2);

    baselayer.rect( dpos, dpos, canvasWidth-dpos*2, canvasHeight-dpos*2);

    if (showText)
    {
      drawHeader(baselayer);
      drawFooter(baselayer);
    }

    baselayer.popStyle();
    baselayer.endDraw();
  }

  private void drawFooter(PGraphics graphics)
  {
    float fontSize = footerFontSize;
    int pos = floor(canvasHeight - fontSize * 2.3) ;

    String text = randInit +" | " +footerText;

    graphics.fill(font_color, 99);
    graphics.textAlign(RIGHT, CENTER);
    graphics.textFont(footerFont);

    graphics.text(text, canvasWidth-dpos, pos);
  }

  private void drawHeader(PGraphics graphics)
  {
    float fontSize = headerFontSize;
    int pos = floor(fontSize *1.5) ;

    graphics.fill(font_color, 128);
    graphics.textAlign(LEFT, CENTER);
    graphics.textFont(headerFont);

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

    String className = getClass().getName();
    int ps = className.lastIndexOf("$");

    String text = className.substring(0, ps);
    String header = text + " - " + dateFormat.format( new Date() );

    graphics.text(header, dpos, pos);
  }
}
