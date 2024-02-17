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
        int rooms = 4;
        jsonList = MakeRoom(15,15,3,jsonList);
        int oldX = 16;
        int oldY = 16;
        int x;
        int y;
        while (startingRooms < rooms) {
            if (d2() == 1) {
                    x = oldX + 6; // figure out a way to get corridors that dont go off the map
                    y = oldY + 6;
                }
                else {
                    x = oldX - 6;
                    y = oldY - 6;
                }
            SendMessageToPC(GetFirstPC(), JsonDump(GetLocationVector(IntToFloat(x),IntToFloat(y),0.0)));
            if (JsonFind(GetLocalJson(GetArea(GetFirstPC()), "DugTiles"), GetLocationVector(IntToFloat(x),IntToFloat(y),0.0)) == JsonNull()) {
                if (oldX < 32 && oldY < 32 && oldX > 0 && oldY > 0) {
                    jsonList = MakeRoom(x,y,d4(),jsonList);
                    if (d2() == 1) {
                        jsonList = HorizontalTunnel(oldX, x, oldY,jsonList);
                        jsonList = VerticalTunnel(oldY, y, x,jsonList);
                    }
                    else {
                        jsonList = VerticalTunnel(oldY, y, oldX,jsonList);
                        jsonList = HorizontalTunnel(oldX, x, y,jsonList);
                    }
                    if (startingRooms == 0) {
                        // Create downstairs
                        string portalTag = InsertString("CDown",IntToString(GetLocalInt(GetModule(), "DLevel")),0);
                        CreateObject(OBJECT_TYPE_PLACEABLE, "cryptdownportal", Location(GetArea(GetFirstPC()), Vector((y+0.5)*10,(x+0.5)*10,0.0),0.0));
                        SetTag(CreateObject(OBJECT_TYPE_WAYPOINT, "nw_wp_stop", Location(GetArea(GetFirstPC()), Vector((y+0.5)*10,(x+0.5)*10,0.0),0.0)),portalTag);
                    }
                    wpList = JsonArrayInsert(wpList, ObjectToJson(CreateObject(OBJECT_TYPE_WAYPOINT, "nw_wp_stop", Location(GetArea(GetFirstPC()), Vector((x+0.5)*10,(y+0.5)*10,0.0),0.0))));
                    json wpLoc = GetLocationVector((y+0.5)*10,(x+0.5)*10,0.0);
                    locList =  JsonArrayInsert(locList, wpLoc);
                    oldX = (x+(x+3))/2 - 1; // get coords for centre of room rounding down (implement flooring function later)
                    oldY = (y+(y+3))/2 - 1 ;
                    startingRooms++;
                    }
                else {
                    oldX = 16;
                    oldY = 16;
                }
            }
        }
        SendMessageToPC(GetFirstPC(),JsonDump(JsonFind(GetLocalJson(GetArea(GetFirstPC()), "DugTiles"), GetLocationVector(IntToFloat(15),IntToFloat(15),0.0))));
        SetTileJson(GetArea(GetFirstPC()), jsonList);
        SendMessageToPC(GetFirstPC(),JsonDump(GetLocalJson(GetArea(GetFirstPC()), "DugTiles")));
        SetLocalInt(GetArea(GetFirstPC()), "Dungeon Created", 1);
        SpawnMons(wpList,GetLocalJson(GetArea(GetFirstPC()), "DugTiles"),10,4);
     }

}
