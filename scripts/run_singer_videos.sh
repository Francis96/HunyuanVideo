#!/bin/bash
# Génère plusieurs variantes d'« un homme qui chante avec un micro ».
# Usage : bash scripts/run_singer_videos.sh [taille: 720|540] [seed]
# Prérequis : GPU NVIDIA >= 45 Go et poids du modèle dans ckpts/ (voir README).

set -e
cd "$(dirname "$0")/.."

RES="${1:-720}"
SEED="${2:-42}"
if [ "$RES" = "540" ]; then SIZE="544 960"; else SIZE="720 1280"; fi

PROMPTS=(
  # 1. Scène de concert intimiste
  "A man in his thirties singing passionately into a vintage microphone on a dimly lit stage, warm spotlight, eyes closed, expressive face, light smoke in the air, cinematic close-up, shallow depth of field, realistic"
  # 2. Grand concert en plein air
  "A charismatic male singer holding a wireless microphone, performing on a large outdoor festival stage at night, colorful stage lights and lasers, crowd silhouettes raising hands in the foreground, dynamic camera movement, realistic, high detail"
  # 3. Studio d'enregistrement
  "A young man singing into a professional condenser microphone with a pop filter in a recording studio, wearing headphones, soft warm lighting, acoustic foam panels in the background, focused and emotional expression, medium shot, realistic"
  # 4. Club de jazz
  "An elderly man in a suit singing softly into a classic chrome microphone in a smoky jazz club, a piano and saxophone player blurred in the background, golden ambient light, slow camera push-in, film grain, realistic"
  # 5. Karaoké entre amis
  "A cheerful man singing karaoke with a handheld microphone in a neon-lit karaoke room, friends laughing and clapping around him, lyrics screen glowing in the background, vibrant pink and blue lights, handheld camera, realistic"
  # 6. Chant gospel / église
  "A Black man singing gospel with a microphone in front of a choir in a bright church, joyful and powerful expression, raising one hand, choir members in robes swaying behind him, warm daylight through stained glass windows, realistic"
)

NEG="blurry, distorted face, deformed hands, extra fingers, low quality, watermark, text"

for i in "${!PROMPTS[@]}"; do
  n=$((i + 1))
  echo "=== Variante $n/${#PROMPTS[@]} ==="
  python3 sample_video.py \
      --video-size $SIZE \
      --video-length 129 \
      --infer-steps 50 \
      --prompt "${PROMPTS[$i]}" \
      --neg-prompt "$NEG" \
      --seed "$SEED" \
      --flow-reverse \
      --use-cpu-offload \
      --save-path "./results/chanteur_$n"
done

echo "Terminé. Vidéos dans ./results/chanteur_*"
