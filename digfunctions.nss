#include "locationobjects"

// Digs a tile, if the tile is outside the boundary then sets it to a value withinn the boundary. (Currently hardcoded to 32x32)

json DigTile(int x, int y, int tile, int orientation, json jsonList) {
      if (x > 31) {
        x = 31;
      }
      if (y > 31) {
        y = 31;
      }
      if (y < 1) {
        y = 1;
      }
      if (x < 1) {
        x = 1;
      }
      // Adds the tile to the list of tiles dug in the level in the current area of the PC
      SetLocalJson(GetArea(GetFirstPC()),"DugTiles",JsonArrayInsert(GetLocalJson(GetArea(GetFirstPC()), "DugTiles"), GetLocationVector(IntToFloat(x),IntToFloat(y),0.0)));
      jsonList = JsonArrayInsert(jsonList, GetSetTileTileObject((32*y)+x, tile, orientation, 0, x, y));
      return jsonList;
}
 // For a set X value, dig a vertical tunnel.
json VerticalTunnel(int y, int y2, int x, json jsonList) {
      int i;
      if (y < y2) {
        for (i = y; i <= y2; i++) {
            jsonList = DigTile(i,x,4,0,jsonList);
        }
      }
      else {
        for (i = y2; i <= y; i++) {
            jsonList = DigTile(i,x,4,0,jsonList);
        }
      }
      return jsonList;
}
 // For a set Y value, dig a horizontal tunnel.
json HorizontalTunnel(int x, int x2, int y, json jsonList) {
      int i;
      if (x < x2) {
        for (i = x; i <= x2; i++) {
            jsonList = DigTile(y,i,4,0,jsonList);
        }
      }
      else {
        for (i = x2; i <= x; i++) {
            jsonList = DigTile(y,i,4,0,jsonList);
        }
      }
      return jsonList;
}

//
json MakeRoom(int x, int y, int size, json jsonList) {
    int i;
        int j;
        json originalList = jsonList;
        json oObject = JsonObject();
        if (x > 31 || y > 31 || x < 1 || y < 1) {
            return originalList;
        }
        for (i = x+1; i < x+size; i++) {
            for (j = y+1; j < y+size; j++) { // dig out all of the inner tiles by avoiding the corners
                jsonList = DigTile(i,j,4,0,jsonList);
            }
        }
        // Horizontal walls
        for (i = x+1; i < x+size; i++) {
            jsonList = DigTile(i,y,118,3,jsonList);
            jsonList = DigTile(i,y+size,118,1,jsonList);
        }
        // Vertical walls
        for (i = y+1; i < y+size; i++) {
            jsonList = DigTile(x,i,118,2,jsonList);
            jsonList = DigTile(x+size,i,118,0,jsonList);
        }
        // Corners
        jsonList = DigTile(x+size,y+size,121,0,jsonList);
        jsonList = DigTile(x+size,y,121,3,jsonList);
        jsonList = DigTile(x,y,121,2,jsonList);
        jsonList = DigTile(x,y+size,121,1,jsonList);
        return jsonList;
}
