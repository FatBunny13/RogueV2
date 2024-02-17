void main()
{
    // Get PC clicker
    object oPC = GetFirstPC();

    SetLocalInt(GetModule(), "DLevel", GetLocalInt(GetModule(), "DLevel") + 1);
    SetLocalString(GetModule(), "Location", "Dungeon");

    // Declare target waypoint
    object oTarget = GetWaypointByTag(InsertString("DUp",IntToString(GetLocalInt(GetModule(), "DLevel")),0));

    // Move oPC, the Player, to oTarget
    SendMessageToPC(oPC,InsertString("D",IntToString(GetLocalInt(GetModule(), "DLevel")),0));
    AssignCommand(oPC, JumpToObject(oTarget));
}
