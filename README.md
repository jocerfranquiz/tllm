# TLLM - Terminal Language Learning Model

TLLM is a command-line interface tool that allows you to interact with Claude, an AI language model, directly from your terminal. It provides a seamless way to send prompts, receive responses, and optionally include context or save outputs to files.

## Features

- Direct interaction with Claude AI from the command line
- Optional input file for providing context
- Optional output file for saving responses
- Configurable API parameters

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/jocerfranquiz/tllm.git
   ```

2. Navigate to the cloned directory:
   ```
   cd tllm
   ```

3. Make the script executable:
   ```
   chmod +x tllm
   ```

4. Move the script to a directory in your PATH (e.g., /usr/local/bin/):
   ```
   sudo mv tllm /usr/local/bin/
   ```

## Configuration

Create a configuration file at `~/.tllm_config` with the following content:

```
MODEL=claude-3-5-sonnet-20240620
API_KEY=your_actual_api_key_here
API_URL=https://api.anthropic.com/v1/messages
MAX_TOKENS=1024
TEMPERATURE=0.7
```

Replace `your_actual_api_key_here` with your Claude API key.

## Usage

Basic usage:
```
tllm "Your prompt here"
```

With input file for context:
```
tllm -i /path/to/input/file.txt "Your prompt here"
```

With output file to save the response:
```
tllm -o /path/to/output/file.txt "Your prompt here"
```

Combining input and output files:
```
tllm -i /path/to/input/file.txt -o /path/to/output/file.txt "Your prompt here"
```

## Examples

1. Simple query:
   ```
   tllm "What is the capital of France?"
   ```

2. Providing context from a file:
   ```
   tllm -i ~/documents/context.txt "Summarize this information"
   ```

3. Saving the response to a file:
   ```
   tllm -o ~/documents/ai_response.txt "Explain quantum computing"
   ```

## Error Handling

The script includes error handling for common issues such as:
- Missing configuration file
- Invalid API key
- Network connection problems
- Invalid command-line arguments

If you encounter any errors, the script will provide informative error messages to help you troubleshoot the issue.

## Contributing

Contributions to TLLM are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://raw.githubusercontent.com/jocerfranquiz/tllm/main/LICENSE) file for details.

## Disclaimer

This tool is not officially associated with Anthropic or Claude AI. It is an independent project designed to interact with the Claude API. Please ensure you comply with Anthropic's terms of service when using this tool.
