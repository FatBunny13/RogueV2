sqlquery AddMonster(string name, int DL, string dungeon) {
     sqlquery monsterTable = SqlPrepareQueryObject(GetModule(), "INSERT INTO monsters (name, DL, location) VALUES(@name, @DL, @location)");
     SqlBindString(monsterTable, "@name", name);
     SqlBindString(monsterTable, "@location", dungeon);
     SqlBindInt(monsterTable, "@DL", DL);
     return monsterTable;
}

sqlquery GetMonster() {
    sqlquery randMonster = SqlPrepareQueryObject(GetModule(), "SELECT * FROM monsters WHERE DL <= @DL AND location = @location ORDER BY RANDOM() LIMIT 1");
    SqlBindInt(randMonster, "@DL", GetLocalInt(GetModule(), "DLevel"));
    SqlBindString(randMonster, "@location", GetLocalString(GetModule(), "Location"));
    SendMessageToPC(GetFirstPC(), GetLocalString(GetModule(), "Location"));
    return randMonster;
}
