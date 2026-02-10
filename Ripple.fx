
sampler2D background_texture : register(s1)  = sampler_state{
    AddressU = Clamp;
    AddressV = Clamp;
};

float freq;
float speed;
float amplitude ;
float centerx;
float centery;

float flip;

float effect;

struct PS_INPUT
{
    float4 p : POSITION;
    float2 v_texcoord0 : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 c     : COLOR0;
};

PS_OUTPUT ps_main(PS_INPUT input)
{
    PS_OUTPUT output;   

    float2 center=float2(centerx,centery);

    float2 toUV = input.v_texcoord0 - center;
    float distanceFromCenter = length(toUV);
    float2 normToUV = toUV / distanceFromCenter;

    float wave = cos(freq * distanceFromCenter - speed * effect);
    float offset1 = effect * wave * amplitude;
    float offset2 = (1.0 - effect) * wave * amplitude;
    
    float2 newUV1 = center + normToUV * (distanceFromCenter + offset1);
    float2 newUV2 = center + normToUV * (distanceFromCenter + offset2);
    
    float4 c1 = tex2D(background_texture, newUV1); 
    float4 c2 = tex2D(background_texture, newUV2);

    output.c=lerp(c1, c2, effect);

    return output;
    
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}