[![Pharo 13](https://github.com/koendehondt/iris-for-pharo/actions/workflows/Pharo13.yml/badge.svg)](https://github.com/koendehondt/iris-for-pharo/actions/workflows/Pharo13.yml) [![codecov](https://codecov.io/gh/koendehondt/iris-for-pharo/graph/badge.svg?token=TJ1JGZUBTM)](https://codecov.io/gh/koendehondt/iris-for-pharo)

[![Pharo 14](https://github.com/koendehondt/iris-for-pharo/actions/workflows/Pharo14.yml/badge.svg)](https://github.com/koendehondt/iris-for-pharo/actions/workflows/Pharo14.yml)

# Iris

A [Model Context Protocol](https://modelcontextprotocol.io) (MCP) server running inside a live [Pharo](https://pharo.org) image.

It allows Claude Desktop (or any MCP client) to inspect and interact with a running Pharo image.

## Tools

| Tool | Description | Parameters |
|------|-------------|------------|
| `pharo:eval` | Evaluates a Smalltalk expression in the Pharo image and returns the `printString` of the result | `expression` *(string, required)* |
| `pharo:get_class` | Returns the definition and all method sources for a named class, both instance-side and class-side | `class_name` *(string, required)* |
| `pharo:get_method` | Returns the source of a single method | `class_name` *(string, required)*, `selector` *(string, required)*, `class_side` *(boolean, optional)* |
| `pharo:list_classes` | Lists all classes in the image, with optional filtering | `prefix` *(string, optional)*, `package` *(string, optional)* |
| `pharo:run_tests` | Runs a `TestCase` subclass (or a single test method) and returns pass/fail/error counts with failure messages. Alternatively, runs all `TestCase` subclasses in a package | `class_name` *(string, optional)*, `package` *(string, optional)*, `selector` *(string, optional)* |

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
    repository: 'github://koendehondt/iris-for-pharo:main';
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

By default, the server runs on port 9999. To run on a custom port, 8888 for instance, evaluate `(IrisMCPServer onPort: 8888) start`.

## Stop the server

```smalltalk
server stop
```

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
