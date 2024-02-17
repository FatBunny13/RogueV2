#include "sqlqueries"

void CreateVillager() {
      object oTarget = GetFirstPC();
      object oArea = GetArea(oTarget);
      int width = GetAreaSize(AREA_WIDTH, oArea)*10; // in feet
      int height = GetAreaSize(AREA_HEIGHT, oArea)*10;
      vector endVector = Vector(IntToFloat(Random(width)), IntToFloat(Random(height)),0.0);  // Get random location from map's width and heigh
      location monsLocation = Location(GetArea(GetFirstPC()), endVector, GetFacing(GetFirstPC()));
      int random = Random(3);
      sqlquery query;
      if (random == 0) {
        query = SqlPrepareQueryObject(GetModule(), "SELECT name FROM monsters WHERE name = 'humanvillager';");
      }
      else if (random == 1) {
        query = SqlPrepareQueryObject(GetModule(), "SELECT name FROM monsters WHERE name = 'humanvillager001';");
      }
      else {
        query = SqlPrepareQueryObject(GetModule(), "SELECT name FROM monsters WHERE name = 'humanvillager002';");
      }
      SqlStep(query);
      CreateObject(OBJECT_TYPE_CREATURE,SqlGetString(query,0),monsLocation);
}

void CreateMonsTable() {
    // dungeon
    SqlStep(AddMonster("humanvillager",0,"Rampart"));
    SqlStep(AddMonster("humanvillager001",0,"Rampart"));
    SqlStep(AddMonster("humanvillager002",0,"Rampart"));
    SqlStep(AddMonster("vanilla_goblin",1,"Dungeon"));
    SqlStep(AddMonster("nw_rat_001",1,"Dungeon"));
    SqlStep(AddMonster("kobold",1,"Dungeon"));
    SqlStep(AddMonster("goblinrockthrowe",3,"Dungeon"));
    SqlStep(AddMonster("koboldpriestess",3,"Dungeon"));
    SqlStep(AddMonster("spritemagician",4,"Dungeon"));
    // crypt
    SqlStep(AddMonster("skeletonranger",0,"Crypt"));
    SqlStep(AddMonster("drowspellsword",3,"Crypt"));
    // wilderness
    SqlStep(AddMonster("cow",0,"Wilderness"));
    SqlStep(AddMonster("housecat",0,"Wilderness"));
    SqlStep(AddMonster("rabiddog",0,"Wilderness"));
    SqlStep(AddMonster("humanbandit",0,"Wilderness"));
}

void main()
{  object oEntering = GetEnteringObject();
   SetLocalString(GetModule(), "Location", "Rampart");
     // make sure its a PC
   if (GetIsPC(oEntering) && GetLocalInt(GetArea(GetFirstPC()), "Dungeon Created") == 0) {
       int numMons = 12 + d12() + Random(5);
       sqlquery monsterTable = SqlPrepareQueryObject(GetModule(), "CREATE TABLE IF NOT EXISTS monsters (name TEXT PRIMARY KEY, DL INT, location TEXT);");
       SqlStep(monsterTable); // Create table, then populate with all monsters
       CreateMonsTable();
       while (numMons > 0) {
          CreateVillager();
          numMons--;
       }
       SetLocalInt(GetArea(GetFirstPC()), "Dungeon Created", 1);
   }

}
