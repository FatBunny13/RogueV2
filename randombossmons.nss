object MakeRare(object monster)
{
    string postfix = GetName(monster);
    SetName(monster, RandomName() + " The " + postfix);
    LevelUpHenchman(monster);
    CreateItemOnObject("nw_it_gold001", monster, 25);
    return monster;
}

object MakeBoss(object monster)
{
    string postfix = GetName(monster);
    int class = Random(2);
    if (class == 0) {
        LevelUpHenchman(monster, 10, TRUE, 31);
        SetName(monster, RandomName() + " The " + postfix + " Evoker");
    }
    else if (class == 1) {
        LevelUpHenchman(monster, 4, TRUE, 4);
        SetName(monster, RandomName() + " The " + postfix + " Fighter");
    }
    CreateItemOnObject("nw_it_gold001", monster, 50);
    return monster;
}
