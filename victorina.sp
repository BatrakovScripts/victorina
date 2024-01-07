#include <sourcemod>

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//*
//*                 Viktorina
//*                 Status: 1.0 Version.
//*					Автор релиза Alexander_Mirny
//*					Плагин размещен на https://forum.myarena.ru/
//*
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define ErrorMessage "\x05У вас недостаточно очков! нужно (%d). Пропишите в чат myscore."

ConVar MaxPrize;
ConVar MaxNumber;
ConVar Second;
ConVar BuyScore;

new Viktorina = -5415614561541;
new Score[MAXPLAYERS];

public OnPluginStart()
{
	BuyScore = CreateConVar("MaxBuyScore", "5000", "Сколько нужно очков игру, что-бы купить оружие.", FCVAR_NOTIFY);
	MaxPrize = CreateConVar("MaxScore", "2000", "Максимальное количество очков.", FCVAR_NOTIFY);
	MaxNumber = CreateConVar("MaxNum", "100", "Максимальное число.", FCVAR_NOTIFY);
	Second = CreateConVar("SecondTimer", "120.0", "Максимальное количество секунд, через сколько появится сообщение. default 120сек = 2минуты.", FCVAR_NOTIFY);
	HookEvent("player_say", player_say);
	CreateTimer(GetConVarFloat(Second), StartVictorina, _, TIMER_REPEAT);
}
public Action StartVictorina(Handle timer)
{
	new a,b;
	a = GetRandomInt(0, GetConVarInt(MaxNumber));
	b = GetRandomInt(0, GetConVarInt(MaxNumber));
	Viktorina = a + b;
	PrintToChatAll("\x03Викторина: \x05Сколько будет \x04%d + \x04%d \x05? (ответ пишем в чате)",a,b);
}
public Action:player_say(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new prize;
	decl String:Text[35];
	GetEventString(event, "text", Text, 35);
	if (StringToInt(Text) == Viktorina)
	{
		prize = GetRandomInt(0, GetConVarInt(MaxPrize));
		PrintToChatAll("\x03Викторина: \x05Игрок \x04%N \x05дал(а) верный ответ! Ответ был: \x04%d. \x05Приз: \x04%d [Score]",client,Viktorina,prize);
		Score[client] += prize;
		Viktorina = -5415614561541;
	}
	if (StrEqual(Text, "myscore"))
	{
		PrintToChat(client,"\x03У вас \x04%d [Score]",Score[client]);
	}
	if (StrEqual(Text, "buygun"))
	{
		new Handle:menu = CreateMenu(GunBuy);
		SetMenuTitle(menu, "Оружие");
		AddMenuItem(menu, "option1", "Shotgun");
		AddMenuItem(menu, "option2", "SMG");
		AddMenuItem(menu, "option3", "Rifle");
		AddMenuItem(menu, "option4", "Hunting Rifle");
		AddMenuItem(menu, "option5", "Auto Shotgun");
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
	return Plugin_Continue;
}
public GunBuy(Handle:menu, MenuAction:action, client, itemNum)
{
	new flags = GetCommandFlags("give");
	SetCommandFlags("give", flags & ~FCVAR_CHEAT);
	 
	if (action == MenuAction_Select) 
	{  
		switch (itemNum)
		{
			case 0:
			{
				if(Score[client] < GetConVarInt(BuyScore)) 
				{	
					PrintToChat(client, ErrorMessage, GetConVarInt(BuyScore));	
				}
				else
				{
					Score[client] -= GetConVarInt(BuyScore);
					FakeClientCommand(client, "give pumpshotgun");
				}
			}
			case 1:
			{
				if(Score[client] < GetConVarInt(BuyScore)) 
				{	
					PrintToChat(client, ErrorMessage, GetConVarInt(BuyScore));	
				}
				else
				{
					Score[client] -= GetConVarInt(BuyScore);
					FakeClientCommand(client, "give smg");
				}
			}
			case 2: 
			{
				if(Score[client] < GetConVarInt(BuyScore)) 
				{	
					PrintToChat(client, ErrorMessage, GetConVarInt(BuyScore));	
				}
				else
				{
					Score[client] -= GetConVarInt(BuyScore);
					FakeClientCommand(client, "give rifle");
				}
			}
			case 3:
			{
				if(Score[client] < GetConVarInt(BuyScore)) 
				{	
					PrintToChat(client, ErrorMessage, GetConVarInt(BuyScore));	
				}
				else
				{
					Score[client] -= GetConVarInt(BuyScore);
					FakeClientCommand(client, "give hunting_rifle");
				}
			}
			case 4:
			{
				if(Score[client] < GetConVarInt(BuyScore)) 
				{	
					PrintToChat(client, ErrorMessage, GetConVarInt(BuyScore));	
				}
				else
				{
					Score[client] -= GetConVarInt(BuyScore);
					FakeClientCommand(client, "give autoshotgun");
				}
			}
		}
	}
	SetCommandFlags("give", flags|FCVAR_CHEAT);
}