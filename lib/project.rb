class Project

	def initialize(name)
		@name = name
		self.checkName
	end

	def checkName
		if !@name
			puts "No Name Provided".red
			exit
		else
			@name = @name.downcase.strip.gsub(' ', '-')
		end
	end

	def create(template)
		self.createApacheConfig(template)
		self.addToHosts
	end

	def createApacheConfig(template)
		if File.writable?($apacheConfigDir)
			inFile = $lib + template + '.conf'
			if template=='default'
				inFile = $lib + template + '.conf'
			else
				inFile = $templateDir + template + '.conf'
				if !File.exists?(inFile)
					puts "Template does not exist at location #{inFile}".red
					exit
				end
			end
			outFile = $apacheConfigDir + @name + '.conf'
			self.backupApacheConfig
			File.open(outFile, 'w') do |out|
				out << File.open(inFile).read.gsub(/{{name}}/, @name).gsub(/{{webroot}}/, $projectsFolder)
			end
			puts "Apache site config generated".green
			`a2ensite #{@name}.conf && service apache2 reload`
		else
			puts "Apache Site Directory (#{$apacheConfigDir}) not writable".red
		end
	end

	def addToHosts
		backedUp = self.backupHosts
		if backedUp && File.writable?($hosts)
			File.open($hosts, 'a') do |hosts|
				hosts.puts("127.0.0.1		#{@name}.dev www.#{@name}.dev")
			end
			puts "#{@name} successfully added to hosts".green
			puts "You may have to restart your browser".green
		else
			puts "Hosts backup failed or hosts is not writable".red
		end
	end

	def backupApacheConfig
		if File.exists?($apacheConfigDir+@name+'.conf')
			FileUtils.cp $apacheConfigDir+@name+'.conf', $backupDir + "#{@name}.conf.backup"
		end
	end

	def backupHosts
		if File.exists?($hosts)
			backup = $backupDir + 'hosts.backup'
			FileUtils.cp $hosts, backup
			puts "Hosts file backed-up at #{backup}".green
			true
		else
			puts "Hosts file does not exists at #{$hosts}, Backup Failed".red
			false
		end
	end

	def remove
		self.removeFromHosts
		self.removeApacheConfig
	end

	def removeFromHosts
		backedUp = self.backupHosts
		if backedUp && File.writable?($hosts)
			temp = File.open($hosts + '.temp', 'a')
			File.open($hosts, 'r').each do |line|
				if !line.include? "#{@name}.dev www.#{@name}.dev"
					temp.puts(line)
				end
			end
			temp.close
			File.delete($hosts)
			FileUtils.mv($hosts+'.temp', $hosts)
			puts "Old domains removed from hosts file".green
		else
			puts "Hosts backup failed or hosts is not writable".red
		end
	end

	def removeApacheConfig
		config = $apacheConfigDir + @name + '.conf'
		if File.writable?(config)
			`a2dissite #{@name}.conf && service apache2 reload`
			File.delete(config)
			puts "Site config delted and apache refreshed".green
		else
			puts "Apaches site config not writable".red
		end
	end

end