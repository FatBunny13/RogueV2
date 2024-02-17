#include "randombossmons"
#include "sqlqueries"

location CheckValidLocation(object area, json wpList, json locList) {
      int index = Random(JsonGetLength(locList));
      json wpLoc = JsonArrayGet(locList, index); // Get random location from list, either from waypoint or from a random coordinate in the DugTiles variable
      return Location(GetArea(GetFirstPC()), Vector(((JsonGetFloat(JsonObjectGet(wpLoc, "x"))+0.5) * 10.0 ),((JsonGetFloat(JsonObjectGet(wpLoc, "y"))+0.5) * 10.0),JsonGetFloat(JsonObjectGet(wpLoc, "z"))), 0.0);
      // when compiler starts throwing unknown errors check if the array holding all the json objects has been properly defined first.
}

void CreateMonster(int difficulty, json wpList, json locList) {
      object oTarget = GetFirstPC();
      object oArea = GetArea(oTarget);
      location monsLocation = CheckValidLocation(oArea, wpList, locList);
      sqlquery monType = GetMonster();
      SqlStep(monType);
      SendMessageToPC(GetFirstPC(), SqlGetString(monType,0));
      object mons = CreateObject(OBJECT_TYPE_CREATURE,SqlGetString(monType,0), monsLocation);
      int random = Random(20);
      SendMessageToPC(GetFirstPC(), JsonDump(ObjectToJson(mons)));
      if (random == 1) {
        MakeBoss(mons);
      }
      else if (random < 4) {
        MakeRare(mons);
      }
      SetCurrentHitPoints(mons, GetMaxHitPoints(mons)+GetLocalInt(GetModule(), "DLevel")); // maybe change to something to do with the PC's level instead to deal with wilderness areas

}

void SpawnMons(json wpList, json locList, int EasyMons, int MediumMons)
{  object oEntering = GetEnteringObject();
     // make sure its a PC
   if (GetIsPC(oEntering)) {
       while (EasyMons > 0) {
          CreateMonster(1, wpList, locList);
          EasyMons--;
       }
       while (MediumMons > 0) {
          CreateMonster(2, wpList, locList);
          MediumMons--;
       }
   }

}
