require 'docopt'

require_relative 'tmux-connector/version'
require_relative 'tmux-connector/command_handler'


module TmuxConnector
  TCON_DOC = <<HERE
tcon enables establishing connections (ssh) to multiple servers and executing
commands on those servers. The sessions can be persisted (actually recreated)
even after computer restarts. Complex sessions with different layouts for
different kinds of servers can be easily created.

Usage:
  tcon start <config-file> [--ssh-config=<file>]
             [--session-name=<name>] [--purpose=<description>]
  tcon resume <session-name>
  tcon delete (<session-name> | --all)
  tcon list
  tcon send <session-name> (<command> | --command-file=<file>)
            [--server-filter=<regex>] [--group-filter=<regex>] [--verbose]
  tcon --help
  tcon --version

Options:
  <config-file>              Path to configuration file. Configuration file
                             describes how new session is started. YAML format.
  <session-name>             Name that identifies the session. Must be unique.
  <command>                  Command to be executed on remote server[s].
  -s --ssh-config=file       Path to ssh config file [default: ~/.ssh/config].
  -n --session-name=name     Name of the session to be used in the tcon command.
  -p --purpose=description   Description of session's purpose.
  --all                      Delete all existing sessions.
  -f --server-filter=regex   Filter to select a subset of the servers.
                             Should be valid ruby regex.
  -g --group-filter=regex    Filter to select a subset of the servers via
                             group membership.  Should be valid ruby regex.
  -c --command-file=file     File containing the list of commands to be
                             executed on remote server[s].
  -v --verbose               Report how many servers were affected by the send
                             command.
  -h --help                  Show this screen.
  --version                  Show version.
HERE

  def self.main(input_args)
    begin
      args = Docopt.docopt TCON_DOC, argv: input_args, version: VERSION
      process_command args
    rescue Docopt::Exit => e
      puts e.message
    rescue => e
      puts "Something went wrong: #{ e.message }"
    end
  end
end
