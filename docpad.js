/* eslint camelcase:0 */
'use strict'

// Require
const helpers = require('outpatient')

// Prepare
const websiteVersion = require('./package.json').version


// =================================
// Configuration

// The DocPad Configuration File
const docpadConfig = {

	// =================================
	// Template Data
	// These are variables that will be accessible via our templates
	// To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData: {

		// -----------------------------
		// Misc

		text: {
			heading: "Bevry's Learning Centre",
			subheading: ' &nbsp; doing everything we can to empower developers',
			poweredby: `
		<a class="hover-link" href="https://docpad.org" title="We use DocPad as our Content Management System">
			Created with love and affection using <span class="link">DocPad</span>
		</a>`,
			copyright: `
		&copy; <a href="https://bevry.me">Bevry Pty Ltd</a>. <a href="https://github.com/bevry/learn">Some rights reserved.</a>`,

			linkNames: {
				learn: 'Learn',
				email: 'Email',
				twitter: 'Twitter',
				github: 'GitHub',
				support: 'Support',
				showcase: 'Showcase'
			},

			links: {
				historyjs: '<a href="https://github.com/browserstate">History.js</a>',
				docpad: '<a href="https://docpad.org">DocPad</a>',
				cclicense: '<a href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution License</a>'
			}
		},
		nodeVersion: process.version,
		nodeMajorMinorVersion: process.version.replace(/^v/, '')
			.split('.').slice(0, 2).join('.'),


		// -----------------------------
		// Site Properties

		site: {
			// The production url of our website
			url: 'https://learn.bevry.me',

			// The default title of our website
			title: "Bevry's Learning Centre",

			// The website keywords (for SEO) separated by commas
			keywords: 'bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node.js, javascript, coffee-script, query-engine',

			// Styles
			styles: [
				'/vendor/normalize.css',
				'/vendor/h5bp.css',
				'/vendor/highlight.css',
				'/styles/style.css'
			].map(function (url) {
				return `${url}?websiteVersion=${websiteVersion}`
			}),

			// Script
			scripts: [
				'//cdnjs.cloudflare.com/ajax/libs/anchor-js/3.2.2/anchor.min.js'
			]
		}

	},

	// =================================
	// Collections

	collections: {

		pages (database) {
			const query = {
				relativeOutDirPath: {
					$startsWith: 'pages'
				}
			}
			const sort = [{
				filename: 1
			}]
			return database.findAllLive(query, sort)
		}

	},



	// =================================
	// Plugins

	plugins: {
		repocloner: {
			repos: [
				{
					name: 'Bevry Documentation',
					path: 'src/documents/learn/bevry',
					url: 'https://github.com/bevry/documentation.git'
				}
			]
		},

		downloader: {
			downloads: [{
				name: 'HTML5 Boilerplate',
				path: 'src/raw/vendor/h5bp.css',
				url: 'https://rawgit.com/h5bp/html5-boilerplate/5.3.0/dist/css/main.css'
			}, {
				name: 'Normalize CSS',
				path: 'src/raw/vendor/normalize.css',
				url: 'https://rawgit.com/h5bp/html5-boilerplate/5.3.0/dist/css/normalize.css'
			}, {
				name: 'Highlight.js GitHub Theme',
				path: 'src/raw/vendor/highlight.css',
				url: 'https://rawgit.com/isagalaev/highlight.js/8.0/src/styles/github.css'
			}]
		},

		cleanurls: {
			simpleRedirects: {
				'/taskgroup/guide': 'https://github.com/bevry/taskgroup/wiki/Introduction-&-Usage',
				'/taskgroup/comparisons': 'https://github.com/bevry/taskgroup/wiki/Compare',
				'/taskgroup/showcase': 'https://github.com/bevry/taskgroup/wiki/Showcase',
				'/taskgroup/api': 'http://rawgit.com/bevry/taskgroup/master/docs/',
				'/joe/guide': 'https://github.com/bevry/joe/wiki/Introduction-&-Usage',
				'/queryengine/guide': 'https://github.com/bevry/query-engine/wiki/Using',
				'/community/chat-guidelines': 'https://discuss.bevry.me/t/irc-chat-rooms/54',
				'/community/coding-standards': 'https://github.com/bevry/base/blob/master/CODING-STANDARDS.md',
				'/community/support-channels': 'https://discuss.bevry.me/t/official-bevry-support-channels/63'
				'/community/support-guidelines': 'https://discuss.bevry.me/t/official-support-guidelines/140'
				'/community/documentation-guidelines': 'https://discuss.bevry.me/t/official-documentation-guidelines/139'
			},

			advancedRedirects: [
				// Old URLs
				[/^https?:\/\/(?:bevry-learn\.herokuapp\.com|bevry\.github\.io\/learn)(.*)$/, 'https://learn.bevry.me$1'],

				// /project/PROJECT => /#PROJECT
				[/^\/project\/(.+)$/, '/#$1'],

				// legacy
				// /PROJECT => /#PROJECT
				// [/^\/(query-engine|joe|taskgroup|community|node)\/?$/, '/#$1']

				// legacy
				// /bevry/* => /community/*
				// [/^\/bevry\/(.*)$/, '/community/$1']

				// DocPad Documentation
				[/^\/learn\/docpad-(.*)$/, 'https://docpad.org/docs/$1'],

				// DocPad General
				[/^\/docpad(?:\/(.*))?$/, 'http://docpad.org/$1']
			]
		}
	}
}

// Apply our helpers to the docpad configuration
helpers({
	config: {
		getUrl ({projectId, name}) {
			return `/${projectId}/${name}`
		},
		docs: {
			title: 'Learning Centre',
			url: '/'
		},
		projects: {
			node: {
				title: 'Node.js',
				categories: {
					handsonnode: {
						title: 'Hands on with Node'
					}
				}
			}
		}
	},
	docpadConfig
})

/*
// Don't use debug log level on travis as it outputs too much and travis complains
// https://travis-ci.org/docpad/website/builds/104133494
if (process.env.TRAVIS) {
	docpadConfig.logLevel = 6
}
*/

// Export our DocPad Configuration
module.exports = docpadConfig
