# Iris

A [Model Context Protocol](https://modelcontextprotocol.io) (MCP) server running inside a live [Pharo](https://pharo.org) image.

It allows Claude Desktop (or any MCP client) to inspect and interact with a running Pharo image.

## Tools

| Tool | Description |
|------|-------------|
| `get_class` | Returns the full definition and all method sources for a named class |
| `get_method` | Returns the source of a single method by class name and selector |
| `list_classes` | Lists all classes, optionally filtered by name prefix or package |
| `eval` | Evaluates a Smalltalk expression and returns the printString of the result |
| `run_tests` | Runs a TestCase class (or single method) and returns pass/fail/error summary |

## Architecture

```
Claude Desktop
    ↕ stdio
mcp-remote (Node.js proxy)
    ↕ HTTP POST /mcp
Pharo Image (Zinc HTTP server on port 9999)
```

## Installation

```smalltalk
Metacello new
    baseline: 'Iris';
    repository: 'github://koendehondt/iris/src:main';
    onConflict: [ :e | e useIncoming ];
    onUpgrade: [ :e | e useIncoming ];
    ignoreImage;
    load
```

## Start the server

```smalltalk
server := IrisMCPServer new.
server start
```

## Stop the server

```smalltalk
server stop
```

Custom port: `(IrisMCPServer onPort: 8888) start`

## Claude Desktop Configuration

Install [mcp-remote](https://github.com/geelen/mcp-remote) and add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "pharo": {
      "command": "/path/to/node",
      "args": [
        "/path/to/mcp-remote/dist/proxy.js",
        "http://localhost:9999/mcp"
      ]
    }
  }
}
```
