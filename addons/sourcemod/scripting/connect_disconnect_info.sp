#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <csgo_colors>

#define TERRORIST_TEAM 2
#define COUNTER_TERRORIST_TEAM 3

public Plugin myinfo =
{
	name = "Connect and Disconnect Info [CS:GO]",
	author = "1mpulse (skype:potapovdima1)",
	description = "Заменяет стандартные сообщение при подкл./откл. игроков",
	version = "1.0.0",
	url = "http://plugins.thebestcsgo.ru"
}
public void OnPluginStart() 
{
	LoadTranslations("connect_disconnect_info.phrases");
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	HookEvent("player_connect", OnPlayerConnect, EventHookMode_Pre);
	HookEvent("player_team", OnPlayerTeam, EventHookMode_Pre);
}

public void OnPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if(!dontBroadcast && !event.GetBool("disconnect") && !event.GetBool("silent") && IsClientInGame(iClient) && !IsFakeClient(iClient))
	{
		char szBuffer[512];
		event.BroadcastDisabled = true;
		int iTeam = event.GetInt("team");
		if(iTeam == COUNTER_TERRORIST_TEAM) FormatEx(szBuffer, sizeof(szBuffer), "%T", "player_team_ct", iClient, iClient);
		else if(iTeam == TERRORIST_TEAM) FormatEx(szBuffer, sizeof(szBuffer), "%T", "player_team_t", iClient, iClient);
		else FormatEx(szBuffer, sizeof(szBuffer), "%T", "player_team_spec", iClient, iClient);
		CGOPrintToChatAll(szBuffer);
	}
}

public void OnPlayerConnect(Event event, const char[] name, bool dontBroadcast)
{
	char sName[128], sReason[192], szBuffer[512];
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if(!dontBroadcast) event.BroadcastDisabled = true;
	event.GetString("reason", sReason, sizeof(sReason));
	event.GetString("name", sName, sizeof(sName));
	FormatEx(szBuffer, sizeof(szBuffer), "%T", "player_connect", iClient, sName);
	CGOPrintToChatAll(szBuffer);
}

public void OnPlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	char sReason[192], szBuffer[512];
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if(!dontBroadcast) event.BroadcastDisabled = true;
	event.GetString("reason", sReason, sizeof(sReason));
	FormatEx(szBuffer, sizeof(szBuffer), "%T", "player_disconnect", iClient, iClient);
	CGOPrintToChatAll(szBuffer);
}