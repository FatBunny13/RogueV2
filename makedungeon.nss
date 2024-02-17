#include "spawnmonsters"
#include "digfunctions"

void main()
{
    object oEntering = GetEnteringObject();
     // make sure its a PC
    if (GetIsPC(oEntering) && GetLocalInt(GetArea(GetFirstPC()), "Dungeon Created") == 0) {  //
        SetLocalJson(GetArea(oEntering), "DugTiles", JsonArray());
        json jsonList = JsonArray();
        json wpList = JsonArray();
        json locList = JsonArray(); // For some reason  NWN lets you perform array operations on null values? Check if json is properly declared every time.
        int startingRooms = 0;
        int rooms = 12;
        jsonList = DigTile(16,15,4,0,jsonList);
        jsonList = DigTile(16,16,4,0,jsonList);
        jsonList = DigTile(15,16,4,0,jsonList);
        jsonList = DigTile(15,15,4,0,jsonList);
        int oldX = 16; // Starting coordinates of room
        int oldY = 15;
        int x;
        int y;
        while (startingRooms < rooms) {
            if (d2() == 1) {
                x = oldX + d4();
                y = oldY + d4();
            }
            else {
                x = oldX - d4();
                y = oldY - d4();
            }
            if (d2() == 1) {
                jsonList = HorizontalTunnel(oldX, x, oldY,jsonList);
                jsonList = VerticalTunnel(oldY, y, x,jsonList);
            }
            else {
                jsonList = VerticalTunnel(oldY, y, oldX,jsonList);
                jsonList = HorizontalTunnel(oldX, x, y,jsonList);
            }
            if (startingRooms == 0) {
                // Create the downstairs portal, along with a waypoint at the centre of corridor
                string portalTag = InsertString("DDown",IntToString(GetLocalInt(GetModule(), "DLevel")),0);
                CreateObject(OBJECT_TYPE_PLACEABLE, "downportal", Location(GetArea(GetFirstPC()), Vector((y+0.5)*10,(x+0.5)*10,0.0),0.0));
                SetTag(CreateObject(OBJECT_TYPE_WAYPOINT, "nw_wp_stop", Location(GetArea(GetFirstPC()), Vector((y+0.5)*10,(x+0.5)*10,0.0),0.0)),portalTag);
            }
            wpList = JsonArrayInsert(wpList, ObjectToJson(CreateObject(OBJECT_TYPE_WAYPOINT, "nw_wp_stop", Location(GetArea(GetFirstPC()), Vector((x+0.5)*10,(y+0.5)*10,0.0),0.0))));
            json wpLoc = GetLocationVector((y+0.5)*10,(x+0.5)*10,0.0);
            locList =  JsonArrayInsert(locList, wpLoc);
            oldX = x;
            oldY = y;
            startingRooms++;
        }
        SetTileJson(GetArea(GetFirstPC()), jsonList);
        SpawnMons(wpList,GetLocalJson(GetArea(GetFirstPC()), "DugTiles"),13,11);
        SetLocalInt(GetArea(GetFirstPC()), "Dungeon Created", 1);
     }

}
