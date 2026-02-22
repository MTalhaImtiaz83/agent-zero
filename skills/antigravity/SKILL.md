---
name: "antigravity"
description: "Complete workflow for using AntiGravity AI to create top-notch animations, short-form videos, and cinematic videos with consistent characters. Covers antigravity-ai.com for image/character generation and the Google AntiGravity IDE + Remotion pipeline for animations."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["video", "animation", "antigravity", "remotion", "consistent-characters", "shortform", "cinematic", "content-creation"]
trigger_patterns:
  - "antigravity"
  - "anti gravity"
  - "create video"
  - "create animation"
  - "short form video"
  - "cinematic video"
  - "consistent characters"
  - "video creator"
  - "remotion animation"
  - "ai video"
  - "tiktok video"
  - "reels video"
  - "youtube shorts"
---

# AntiGravity AI Video Creation Skill

This skill enables Agent Zero to create professional animations, short-form social videos, and cinematic content with consistent AI-generated characters using the AntiGravity AI ecosystem.

## Overview

AntiGravity AI consists of two complementary tools:

1. **antigravity-ai.com** — AI-powered image/video platform for consistent character generation. Anchors to reference images and applies style/lighting changes while preserving character identity.
2. **Google AntiGravity IDE (antigravityai.org)** — Free agent-first AI development environment that combines with **Remotion** (open-source React animation framework) for automated video creation pipelines.

## Quick Start

### Creating a Short-Form Video with Consistent Characters

1. **Define your character** - Describe appearance, outfit, style, color palette
2. **Generate reference** - Use `browser_agent` to open antigravity-ai.com and create the character anchor image
3. **Plan scenes** - Break video into 3-7 scene descriptions
4. **Generate scenes** - Use character reference + scene prompts in AntiGravity AI
5. **Assemble** - Use FFmpeg or Remotion to stitch scenes, add audio
6. **Export** - Optimize for target platform

### Creating an Animation with Google AntiGravity + Remotion

1. Open antigravityai.org in browser (free, no signup required for preview)
2. Connect to Remotion: `npx create-video@latest`
3. Prompt: "Create a [X]-second animation for [purpose] with [brand colors/style]"
4. Review preview and refine prompt
5. Export and download

## Detailed Workflows

### Workflow 1: Consistent Character Video Series

Use this when creating multiple videos with the same character.

```
Step 1: Character Locking
- Open antigravity-ai.com via browser_agent
- Upload or generate a base character image
- Prompt: "Character portrait: [describe appearance], [art style], clean background, front-facing, high detail"
- Save this as your "character anchor" reference

Step 2: Scene Generation
- For each scene, upload the character anchor
- Prompt template: "Same character from reference image, [new scene description], [background], [lighting], [emotion/expression], maintain exact same art style and character features"
- Transformation strength: 0.3-0.5 (low = more faithful to reference)
- Generate 3-5 variations per scene, pick best

Step 3: Video Assembly
- Download all scene images
- Use FFmpeg to create slideshow: ffmpeg -framerate 1/3 -pattern_type glob -i '*.png' -c:v libx264 -r 30 output.mp4
- Add transitions: ffmpeg -i output.mp4 -vf "fade=t=in:st=0:d=0.5" final.mp4
- Add voiceover and music with ffmpeg audio mixing

Step 4: Platform Optimization
- TikTok/Reels: ffmpeg -i final.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1" vertical.mp4
- YouTube: ffmpeg -i final.mp4 -vf "scale=1920:1080" landscape.mp4
```

### Workflow 2: AntiGravity + Remotion Animation

Use this for branded animations, motion graphics, and explainer videos.

```
Step 1: Setup (one-time)
- Install Node.js if not present: apt-get install nodejs npm
- Create Remotion project: npx create-video@latest my-animation
- Install deps: cd my-animation && npm install

Step 2: Generate with Google AntiGravity
- Open antigravityai.org in browser
- Connect your Remotion project
- Prompt: "Create a [duration]-second branded animation showing [content] with colors [hex codes] and style [description]"
- AntiGravity generates the Remotion code and assets

Step 3: Preview and Refine
- Run: npx remotion preview
- Adjust prompts until satisfied
- Fine-tune timing, colors, transitions in the generated code

Step 4: Render
- Render MP4: npx remotion render src/index.ts MyVideo out/video.mp4
- Render GIF: npx remotion render --codec=gif src/index.ts MyVideo out/animation.gif
- Render image sequence: npx remotion render --sequence src/index.ts MyVideo out/frames/
```

### Workflow 3: Cinematic Video Production

Use this for high-quality narrative content with cinematic look.

```
Step 1: Pre-Production
- Write a detailed scene-by-scene breakdown
- Define: camera angles, lighting style, color palette, character descriptions
- Choose aspect ratio: 16:9 (standard) or 21:9 (cinematic)

Step 2: Character & Scene Generation
- Use antigravity-ai.com for character reference images
- Use Runway ML, Kling AI, or Google Veo for video clips:
  - Open the platform via browser_agent
  - Upload character reference + scene description
  - Generate 3-5 second clips per scene
  - Download all clips

Step 3: Cinematic Post-Processing
- Stitch clips: ffmpeg -f concat -i filelist.txt -c copy raw_cut.mp4
- Apply LUT for cinematic grade: ffmpeg -i raw_cut.mp4 -vf lut3d=cinematic.cube graded.mp4
- Add letterbox for 21:9: ffmpeg -i graded.mp4 -vf "pad=iw:iw*9/21:(ow-iw)/2:(oh-ih)/2:black" cinema.mp4
- Add score/soundtrack: ffmpeg -i cinema.mp4 -i music.mp3 -c:v copy -c:a aac final_cinematic.mp4

Step 4: Export
- High quality: ffmpeg -i final_cinematic.mp4 -c:v libx264 -crf 18 -preset slow output_hq.mp4
- Web optimized: ffmpeg -i final_cinematic.mp4 -c:v libx264 -crf 23 -preset fast output_web.mp4
```

## Platform Guidelines

### antigravity-ai.com
- **Accepted formats**: JPEG, PNG, WEBP (up to 10MB, max 4096×4096)
- **Transformation strength**: 0.2-0.4 for consistent characters, 0.6-0.8 for creative exploration
- **Best practices**:
  - Clear backgrounds and sharp focus for reference images
  - Specify "must-keep" elements explicitly in prompts
  - Batch generate for efficiency
  - Export high-res for professional use

### Google AntiGravity IDE (antigravityai.org)
- **Cost**: Free during public preview
- **AI models**: Gemini 3 Pro, Claude Sonnet, GPT-OSS
- **Best for**: Automated video pipelines, Remotion animations, multi-agent workflows
- **Integration**: Works alongside Claude Code for parallel rendering

### Remotion
- **GitHub**: github.com/remotion-dev/remotion
- **Tech**: React + TypeScript rendered to video
- **Renders**: MP4, WebM, GIF, image sequences, audio
- **Use cases**: Branded animations, data visualizations, programmatic video

## Character Consistency Tips

1. **Always use a reference image** - Never generate new characters from scratch for each scene
2. **Lock style keywords** - Include the same style descriptors in every prompt (e.g., "anime style", "3D render", "watercolor")
3. **Specify must-keep features** - Explicitly mention: hair color, eye color, outfit, accessories
4. **Low transformation strength** - Keep at 0.3-0.5 to stay faithful to reference
5. **Same session generation** - Generate all scenes in one AntiGravity session for maximum consistency
6. **Test before full production** - Generate 2-3 test scenes and verify consistency before full batch

## Output Formats by Platform

| Platform | Aspect Ratio | Resolution | Duration | Format |
|----------|-------------|------------|----------|--------|
| TikTok | 9:16 | 1080×1920 | 15s-10min | MP4 H.264 |
| Instagram Reels | 9:16 | 1080×1920 | 15s-90s | MP4 H.264 |
| YouTube Shorts | 9:16 | 1080×1920 | Up to 60s | MP4 H.264 |
| YouTube | 16:9 | 1920×1080 | Any | MP4 H.264 |
| LinkedIn | 16:9 | 1920×1080 | Up to 10min | MP4 H.264 |
| Cinema | 21:9 | 2560×1080 | Any | MP4 H.265 |

## Example Prompts

### Character Creation (antigravity-ai.com)
```
A young woman named Maya, 25 years old, shoulder-length black hair with subtle blue highlights,
warm brown eyes, wearing a white blazer over a teal shirt, confident smile.
Art style: semi-realistic digital illustration, clean lines, vibrant colors.
White background, front-facing portrait, high detail.
```

### Scene Generation with Character Anchor
```
[Upload Maya reference image]
Same character as reference image - Maya presenting to an audience in a modern conference room,
gesturing with one hand toward a holographic display, professional lighting from left,
maintain exact same hair, eyes, outfit from reference, add subtle excitement expression.
Transformation strength: 0.35
```

### Remotion Animation Prompt (Google AntiGravity)
```
Create a 30-second animated intro video for a tech startup called "NovaTech".
Colors: deep blue (#0A1628) background, electric cyan (#00D4FF) accents, white text.
Style: clean, modern, minimal.
Sequence: 1) Logo appears with particle effect (0-5s), 2) Tagline types in (5-12s),
3) Three feature icons slide in from left (12-22s), 4) CTA button pulses (22-30s).
Font: Inter Bold for headlines, Inter Regular for body.
```

## Troubleshooting

**Character drifts between scenes**: Lower transformation strength to 0.2-0.3 and add more specific must-keep element descriptions.

**Video clips don't match**: Ensure you're uploading the exact same reference image for each generation, not a variation.

**Remotion render fails**: Run `npm install` in the project directory and check Node.js version (requires 18+).

**FFmpeg not found**: Install with `apt-get install ffmpeg` or use code execution tool to run install.

**AntiGravity IDE not connecting to Remotion**: Ensure Remotion project is running (`npx remotion preview`) before connecting from AntiGravity IDE.
