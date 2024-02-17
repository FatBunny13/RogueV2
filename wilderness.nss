#include "spawnmonsters"
#include "locationobjects"

void main()
{
    json locList = JsonArray();
    json wpList = JsonArray();
    SetLocalInt(GetModule(), "DLevel", 1);
    SetLocalString(GetModule(), "Location", "Wilderness");
    SendMessageToPC(GetFirstPC(), GetLocalString(GetModule(), "Location"));
    int wps = 50;
    while (wps > 0) {
        int x = Random(16);
        int y = Random(16);
        json wpLoc = GetLocationVector((y+0.5),(x+0.5),0.0);
        locList =  JsonArrayInsert(locList, wpLoc);
        wpList = JsonArrayInsert(wpList, ObjectToJson(CreateObject(OBJECT_TYPE_WAYPOINT, "nw_wp_stop", Location(GetArea(GetFirstPC()), Vector((x+0.5)*10,(y+0.5)*10,0.0),0.0))));
        wps--;
    }
    SpawnMons(wpList,locList,30,12);

}
