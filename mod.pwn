// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <a_mysql>
#include <sscanf2>

#define SQL_HOST        "127.0.0.1"
#define SQL_DB          "wpasite"
#define SQL_USER        "root"
#define SQL_PASS        ""
#define TABLE_ACCOUNT   "accounts"

enum pInfo
{
    pID,
    pPassword[256],
    pAdmin,
    pLevel,
    pMoney,
    pVip,
    pSkin,
    pLeader,
    pMember,
    pBan,
    pKills,
    pDeaths,
    pHealths,
    pClass,
    pLang
}

main()
{
	print("\n----------------------------------");
	print("WPA RP v0.1");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("WPA RP v0.1");
 	SendRconCommand("hostname WePlay-Arena RolePlay | Green");
 	AddPlayerClass(0,1761.5269,-1899.5585,13.5635,269.7081,0,0,0,0,0,0); // Spawn in Los Santos
 	DisableInteriorEnterExits();
 	EnableStuntBonusForAll(0);
	return 1;
}

stock OnPlayerLogin(playerid) // Логинизация игрока
{
    new pname[256];
    GetPlayerName(playerid, pname, sizeof(pname));
        format(query,sizeof(query), "SELECT * FROM "TABLE_ACCOUNT" WHERE name = '%s' LIMIT 1",pname); // Вытаскиваем из базы данных игрока с ником равным "pname"
        mysql_query(query);
        mysql_store_result();
        if(mysql_fetch_row(query) == 1)
        {
            sscanf(query, "p<|>s[32]s[32]iiiiiiiiiiiiiiii", // Здесь все просто: s - string, то есть то, что, проще говоря, с буквами. i - цифры, такие как уровень, ID игрока, скин и так далее. f - Float:, то бишь, позиция, любая.
                pname,
                Player[playerid][pPassword],
                Player[playerid][pID],
                Player[playerid][pLevel],
                Player[playerid][pMute],
                Player[playerid][pAdmin],
                Player[playerid][pMoney],
                Player[playerid][pExp],
                Player[playerid][pVip],
                Player[playerid][pSkin],
                Player[playerid][pLeader],
                Player[playerid][pMember],
                Player[playerid][pBan],
                Player[playerid][pKills],
                Player[playerid][pDeaths],
                Player[playerid][pHealths],
                Player[playerid][pClass],
                Player[playerid][pLang]
                );
        mysql_free_result();
        }

        if(Player[playerid][pBan] == 1) // Если игрок забанен на сервере, то:
        {
            SendClientMessage(playerid,COLOR_RED,"x {FFFFFF}Ваш аккаунт заблокирован на сервере."); // Пишем ему об этом.
            Kick(playerid); // И кикаем.
        }

        if(Player[playerid][pVip] >= 1)
        {
            new strin[200];
                format(strin, sizeof(strin), "{FF0000}• {FFFFFF}Ваш аккаунт авторизован с VIP статусом {77e654}[%d lvl].", Player[playerid][pVip]);
                SendClientMessage(playerid,COLOR_LIGHTRED,strin);
        }

        if(Player[playerid][pAdmin] >= 1)
        {
            new strin[200];
            format(strin, sizeof(strin), "{FF0000}• {FFFFFF}Ваш аккаунт авторизован со статусом администратора  {77e654}[%d lvl].", Player[playerid][pAdmin]);
                SendClientMessage(playerid,COLOR_LIGHTRED,strin);
        }

        new strin[200];
        format(strin, sizeof(strin), "{FF0000}• {FFFFFF}Добро пожаловать, {77e654}%s.", GetPlayerName(playerid));
        SendClientMessage(playerid,COLOR_LIGHTRED,strin);

        SetSpawnInfo(playerid, 255, 0, 0, 0, 0, 1.0, -1, -1, -1, -1, -1, -1);
        ServerGivePlayerMoney(playerid, Player[playerid][pMoney]);
        SpawnPlayer(playerid);
}

stock OnPlayerRegister(playerid, pass[]) // Регистрация:
{
    new pname[256];
    GetPlayerName(playerid, pname, sizeof(pname));
        format(query, sizeof(query), "INSERT INTO "TABLE_ACCOUNT" (name, password) VALUES ('%s', '%s')" // Вносим в таблицу с акаунтами имя и пароль игрока.
        ,pname, pass);
        mysql_query(query);
}

stock OnPlayerSave(playerid)
{
        if(IsPlayerConnected(playerid))
        {
                new src[1024], pname[256];
                GetPlayerName(playerid, pname, sizeof(pname));
                format(query,sizeof(query),"UPDATE "TABLE_ACCOUNT" SET "); // Обновляем таблицу с аккаунтами:


                format(src,sizeof(src),"password=%i,",Player[playerid][pPassword]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"userid=%i,",Player[playerid][pID]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"level=%i,",Player[playerid][pLevel]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"mute=%i,",Player[playerid][pMute]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"admin=%i,",Player[playerid][pAdmin]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"money=%i,",GetPlayerMoney(playerid));
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"exp=%i,",Player[playerid][pExp]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"vip=%i,",Player[playerid][pVip]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"skin=%i,",Player[playerid][pSkin]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"leader=%i,",Player[playerid][pLeader]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"member=%i,",Player[playerid][pMember]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"Ban=%i",Player[playerid][pBan]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"kills=%i,",Player[playerid][pKills]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"deaths=%i,",Player[playerid][pDeaths]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"healths=%i,",Player[playerid][pHealths]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"class=%i,",Player[playerid][pClass]);
                strcat(query,src,sizeof(query));
                format(src,sizeof(src),"lang=%i,",Player[playerid][pLang]);
                strcat(query,src,sizeof(query));


                format(src,sizeof(src)," WHERE name='%s'",pname); // У игрока имя которого - pname
                strcat(query,src,sizeof(query));
                mysql_query(query);
        }
        else SendClientMessage(playerid,COLOR_WHITE,"");
}

stock GetAccount(username[], obtaining[])
{
        new QueryAcc[255];
        format(QueryAcc, sizeof(QueryAcc), "SELECT %s FROM "TABLE_ACCOUNT" WHERE name = '%s' LIMIT 1", obtaining, username);
    mysql_query(QueryAcc);
    mysql_store_result();
    if(mysql_fetch_row(QueryAcc) == 1)
    {
        mysql_free_result();
        return QueryAcc;
    }
    return QueryAcc;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
    for(new i; i < 20; i++) SendClientMessage(playerid, -1, "");
	ShowPlayerDialog(playerid,9815,DIALOG_STYLE_MSGBOX,"{FFFF00}WePlay-Arena Role Play{FFFFFF}","{ffe4b2}Добро пожаловать на сервер.\n   {ffe4b2}Подождите полной загрузки сервера\n      и нажмите","Далее","Выход");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
if(Player[playerid][pLeader] == 0 && Player[playerid][pMember] == 0) // Если игрок нигде не состоит, то:
{
        SetPlayerPos(playerid, 1761.5269,-1899.5585,13.5635); // Отправляем его на эти координаты.
        SetPlayerInterior(playerid,0); // Ставим нулевой интерьер, так как он на улице.
        SetPlayerColor(playerid); // Ставим синий цвет, измените на свой или уберите вообще.
        SetCameraBehindPlayer(playerid); // И двигаем камеру к игроку во избежании возможных багов с камерой.
}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 9815)
	{
        if(response)
        {
                new pname[256];
                GetPlayerName(playerid, pname, sizeof(pname));
                format(query, sizeof(query), "SELECT * FROM "TABLE_ACCOUNT" WHERE name = '%s'",  pname);
                mysql_query(query);
                mysql_store_result();
                if(mysql_fetch_row_format(query))
                {
                        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT,
                        "{FFFF00}WePlay-Arena Role Play | Green{FFFFFF}",
                        "{FFFFFF}Здравствуйте, пожалуйста введите ваш пароль.\n{FFFFFF}Ваш аккаунт: {00ff23}зарегистрирован{FFFFFF}.",
                        "Далее", "Выход");
                }
                else
                {
                        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT,
                        "{FFFF00}WePlay-Arena Role Play | Green{FFFFFF}",
                        "{FFFFFF}Здравствуйте, пожулуйста зарегистриуйтесь введя пароль.\n{FFFFFF}Ваш аккаунт: {ff001c}не зарегистрирован{FFFFFF}.",
                        "Далее", "Выход");
        		}
       	}
	}
if(dialogid == 0) // Если зарегистрирован:
    {
        if(response)
        {
        		if(strlen(inputtext) != 0) // Если в поле пароля что то ввели, то делаем следущее:
                {
                new pname2[MAX_PLAYER_NAME]; // Объявляем ник.
                	GetPlayerName(playerid, pname2, MAX_PLAYER_NAME); // Узнаем ник.
                	if(!strcmp(inputtext, GetAccount(pname2, "password"), true)) OnPlayerLogin(playerid); // Дословно: Если введенный текст соответствует паролю аккаунта, то логиним игрока.
                else	// Если введенный текст НЕ соответствует паролю, то опять повторяем диалог:
                	{
                    	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT,
                    		"{FFFF00}WePlay-Arena Role Play | Green{FFFFFF}",
                        	"{FFFFFF}Здравствуйте, пожалуйста введите Ваш пароль\nВаш аккаунт {00ff23}зарегистрирован{FFFFFF}.",
                        	"Войти", "Выход");
                    }
                }
                    else	// Если ничего не ввели, то опять повторяем диалог:
                    {
                    	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT,
                        	"{FFFF00}WePlay-Arena Role Play | Green{FFFFFF}",
                        	"{FFFFFF}Здравствуйте, пожалуйста введите Ваш пароль\n{FFFFFF}Ваш аккаунт: {00ff23}зарегистрирован{FFFFFF}.",
                        	"Войти", "Выход");
                    }
        }
        else // Если игрок нажал выход, то:
        {
            Kick(playerid); // Вышвыриваем его, зачем такие нужны?
        }
    }
if(dialogid == 1) // Если НЕ зарегистрирован:
    {
        if(response)
        {
        		if(strlen(inputtext) != 0) // Если в поле пароля что то ввели, то делаем следущее:
                {
                	OnPlayerRegister(playerid,inputtext); // Регистрируем
                }
                else // Если нет, то:
                {
                	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT,
                        "{FFFF00}WePlay-Arena Role Play | Green{FFFFFF}",
                        "{FFFFFF}Здравствуйте, пожулуйста зарегистриуйтесь введя пароль.\n{FFFFFF}Ваш аккаунт: {ff001c}не зарегистрирован{FFFFFF}.",
                        "Далее", "Выход");
                }
        }
        else
        {
            Kick(playerid);  // Опять вышвыриваем его, че он опять пришел?
        }
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
