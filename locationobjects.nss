// JSON object to represent an ingame tile

json GetSetTileTileObject(int nIndex, int nTileID, int nOrientation, int nHeight, int x, int y) // stolen from daz on nwn discord ty very much
{
    json jTile = JsonObject();
    jTile = JsonObjectSet(jTile, "index", JsonInt(nIndex));
    jTile = JsonObjectSet(jTile, "tileid", JsonInt(nTileID));
    jTile = JsonObjectSet(jTile, "orientation", JsonInt(nOrientation));
    jTile = JsonObjectSet(jTile, "height", JsonInt(nHeight));
    jTile = JsonObjectSet(jTile, "x", JsonInt(x));
    jTile = JsonObjectSet(jTile, "y", JsonInt(y));
    return jTile;
}


// JSON object to represent a set of coordinates for an object
json GetLocationVector(float x, float y, float z)
{
    json jTile = JsonObject();
    jTile = JsonObjectSet(jTile, "x", JsonFloat(x));
    jTile = JsonObjectSet(jTile, "y", JsonFloat(y));
    jTile = JsonObjectSet(jTile, "z", JsonFloat(z));
    return jTile;
}
