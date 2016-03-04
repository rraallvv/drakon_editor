//
//  DRAKONEditorAppDelegate.m
//  DRAKONEditor
//
//  Created by Stepan Mitkin on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DRAKONEditorAppDelegate.h"
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 2000

static FILE* g_logger = 0;
static BOOL hasTCL = NO;
static char pathToTcl[BUFFER_SIZE];
static NSString *diagramFile = nil;

int GetCommandOutput(const char* command, char* output, int length)
{
	FILE* handle;
	int c, i;
	fprintf(g_logger, "GetCommandOutput command:\n%s\n", command);
	handle = popen(command, "r");
	if (handle == 0) { return 0; }

	c = getc(handle);
	i = 0;
	while (i < length - 1 && c != EOF)
	{
		if (c != '\n')
		{
			output[i] = (char)c;
			i++;
		}
		c = getc(handle);
	}
	output[i] = 0;
	fprintf(g_logger, "GetCommandOutput output:\n%s\n", output);

	pclose(handle);
	if (c == EOF)
	{
		return i > 0;
	}
	else
	{
		return 0;
	}
}

int GetPathToTcl(char* output, int length)
{
	if (GetCommandOutput("which tclsh8.6", output, length))
	{
		return 1;
	}

	if (GetCommandOutput("ls /usr/local/bin/tclsh8.6 2>/dev/null", output, length))
	{
		return 1;
	}

	return 0;
}

char *GetPathToDiagram(int argc, char *argv[])
{
	char *ext;

	int i;
	for (i = 0; i < argc; i++)
	{
		ext = strrchr(argv[i], '.');
		if (ext != NULL)
		{
			if (strcmp(ext, ".drn") == 0)
			{
				return argv[i];
			}
		}
	}

	return NULL;
}

static void InitLogger(void)
{
	g_logger = stdout;
}

static void CloseLogger(void)
{
	if (g_logger != 0 && g_logger != stdout)
	{
		fclose(g_logger);
		g_logger = 0;
	}
}

int LaunchScript(const char *diagramPathC)
{
	NSString* tclsh = [[NSString alloc] initWithUTF8String:pathToTcl];
	NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString* pathToScript = @"/tcl/drakon_editor.tcl";
	NSString* fullScriptPath = [resourcePath stringByAppendingString:pathToScript];

	const char* tclPathC = [tclsh UTF8String];
	const char* scriptPathC = [fullScriptPath UTF8String];
	fprintf(g_logger, "tclsh:\n%s\n", tclPathC);
	fprintf(g_logger, "script:\n%s\n", scriptPathC);
	if (diagramPathC)
	{
		fprintf(g_logger, "diagram:\n%s\n", diagramPathC);
	}

	CloseLogger();

	pid_t pid = fork();
	if (pid == 0)
	{
		// This is the child process.
		execl(tclPathC, tclPathC, scriptPathC, diagramPathC, NULL);
	}
	return 1;
}

@implementation DRAKONEditorAppDelegate {
	NSWindowController *_wc;
}

@synthesize window;

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	InitLogger();
	hasTCL = GetPathToTcl(pathToTcl, BUFFER_SIZE);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (hasTCL)
	{
		LaunchScript(diagramFile.UTF8String);
		[NSApp terminate:nil];
	}
	else
	{
		[self.window setIsVisible:YES];
	}
}

- (BOOL)application:(NSApplication *)application openFile:(NSString *)file {
	diagramFile = file;
	return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
	return YES;
}

- (IBAction)goToTclPage:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"http://www.activestate.com/activetcl/downloads"]];	
}

@end
