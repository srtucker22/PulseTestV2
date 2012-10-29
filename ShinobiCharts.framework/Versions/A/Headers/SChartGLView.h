//
//  SChartGLView.h
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "SChartAnimationCurve.h"

#define SHINOBI_MAX_THIN_LINE_WIDTH 2.0f

typedef struct
{
    float zoomX, zoomY;
    float minX,  minY;
} SChartGLTranslation;

typedef struct {
    BOOL   useStencilTest;
    BOOL   incrementStencilPlane;
    GLenum stencilOp;
    GLenum stencilFunc;
} SChartGLStencilParams;

typedef struct {
    float                duration;
    SChartAnimationCurve curve;
    float                scale[2];
    float                refPoint[2];
} SChartGLAnimationParams;

@interface SChartGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    UIColor *areaColor;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    GLuint _lineVertexBuffer;
    GLuint _radialVertexBuffer;
    GLuint _offsetVertexBuffer;
    GLuint _vertexWithWidthBuffer;
    
    GLuint _framebuffer;
    GLuint _colorRenderBuffer;
    GLuint _depthStencilRenderBuffer;
    
    GLuint _framebufferMSAA;
    GLuint _colorRenderBufferMSAA;
    
    GLuint vertexShader;
    GLuint vertexShaderAnimate;
    GLuint vertexShaderOffset;
    GLuint vertexShaderOffsetThickLine;
    GLuint vertexShaderOffsetThickLineDisplaceRotate;
    GLuint vertexShaderPoint;
    GLuint vertexShaderPointDisplaceRotate;
    GLuint vertexShaderPointWithRadius;
    GLuint vertexShaderDisplaceRotate;
    GLuint vertexShaderDisplaceRotateTexture;
    GLuint fragmentShader;
    GLuint fragmentShaderTexture;
    GLuint fragmentShaderPoint;
    GLuint fragmentShaderThickLine;
    GLuint programHandle;
    GLuint programHandleAnimate;
    GLuint programHandlePoint;
    GLuint programHandlePointWithRadius;
    GLuint programHandleThickLine;
    GLuint programHandleOffset;
    GLuint programHandleOffsetThickLine;
    GLuint programHandleRadialSlice;
    GLuint programHandleRadialEffect;
    GLuint programHandleThickLineRadial;
    GLuint programHandleOffsetThickLineRadial;
    GLuint lastUsedProgram;
    GLuint _positionSlot;
    GLuint _colourSlot;
    GLuint _positionSlotAnimate;
    GLuint _colourSlotAnimate;
    GLuint _positionSlotOffset;
    GLuint _colourSlotOffset;
    GLuint _offsetMultiplerSlot;
    GLuint _positionSlotOffsetThickLine;
    GLuint _colourSlotOffsetThickLine;
    GLuint _offsetMultiplerSlotThickLine;
    GLuint _positionSlotOffsetThickLineRadial;
    GLuint _colourSlotOffsetThickLineRadial;
    GLuint _offsetMultiplerSlotThickLineRadial;
    GLuint _positionSlotPoint;
    GLuint _colourSlotPoint;
    GLuint _positionSlotPointWithRadius;
    GLuint _colourSlotPointWithRadius;
    GLuint _radiusSlotPointWithRadius;
    GLuint _positionSlotThickLine;
    GLuint _colourSlotThickLine;
    GLuint _positionSlotThickLineRadial;
    GLuint _colourSlotThickLineRadial;
    GLuint _positionSlotRadialSlice;
    GLuint _colourSlotRadialSlice;
    GLuint _positionSlotRadialEffect;
    GLuint _colourSlotRadialEffect;
    GLuint _uvSlotRadialEffect;
    
    BOOL performCalculations;
    BOOL updateLineTriangles;
    BOOL needsResize;
    BOOL usePremultipliedAlpha;
    BOOL frameBufferInitialised;
    NSMutableArray *allTextures;
    
    NSMutableArray *allVertices;
    NSMutableArray *allIndices;
    NSMutableArray *allDynamicVertices;
    NSMutableArray *allRadialVertices;
    NSMutableArray *allOffsetVertices;
    NSMutableArray *allVerticesWithWidth;
    
    NSMutableArray *depthValuesForDynamicBatches;
    NSMutableArray *radialSliceIndices;
    NSMutableArray *renderDataIndicesOpaque;
    NSMutableArray *renderDataIndicesTransparent;
    
    NSMutableArray *renderQueueOpaque;
    NSMutableArray *renderQueueTransparent;
    NSMutableArray *renderQueueDeferredEffect;
    
    float renderBufferWidth;
    float renderBufferHeight;
    
    // Uniform index.
    GLint *uniforms;
    GLint *uniformsAnimate;
    GLint *uniformsOffset;
    GLint *uniformsOffsetThickLine;
    GLint *uniformsOffsetThickLineRadial;
    GLint *uniformsPoint;
    GLint *uniformsPointWithRadius;
    GLint *uniformsThickLine;
    GLint *uniformsThickLineRadial;
    GLint *uniformsRadialSlice;
    GLint *uniformsRadialEffect;
    
    GLuint spriteTexture;
    GLuint spriteTextureOpaque;
    GLuint bevelEffectTexture;
    GLuint bevelEffectTextureLight;
    GLuint bevelPieEffectTexture;
    GLuint bevelPieEffectTextureLight;
    GLuint roundEffectTexture;
    GLuint roundEffectTexturePie;
    GLuint roundEffectTextureLight;
    GLuint roundEffectTextureLightPie;
    GLuint defaultDonutTexture;
    GLuint defaultPieTexture;
    // NOTE: When you add a new texture here, make sure to increment USER_TEXTURE_START_OFFSET in SChartGLView.mm
    
    float spriteTextureSize;
    
    float currentDepth;
    double animationTime;
    double lastFrameTime;
    BOOL animationActive;
    BOOL animationPaused;
    int dynamicVertexCounter;
    int numDynamicVertexBatches;
    int numRadialSlices;
    int numRenderDataOpaque;
    int numRenderDataTransparent;
}

#pragma mark -
#pragma mark OpenGL Initialisation Methods

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic, readonly) CGRect glBounds;

- (float) glWidth;
- (float) glHeight;

@property (nonatomic, assign) BOOL performCalculations;
@property (nonatomic, assign) BOOL updateLineTriangles;
@property (nonatomic, retain) NSMutableArray *allTextures;

-(GLuint) getFramebuffer;
-(GLuint) getColorRenderBuffer;

-(CAEAGLLayer *) getEAGLLayer;
-(EAGLContext *) getContext;

// Setting up the OpenGL ES 2.0 pipeline */

// @name setupLayer */
// Sets up a CAEAGLLayer */
- (void)setupLayerWithBackgroundColor:(UIColor*)backgroundColor;
@property (nonatomic, retain) UIColor *areaColor;

// Resize the render buffer and recalculate the viewport
- (void)resize;

// @name setupFrameBuffer */
// Sets up a FrameBuffer */
- (void)setupFrameBuffer;

// @name deleteFrameBuffer */
// Deletes the FrameBuffer */
- (void)deleteFrameBuffer;

// @name compileShader */
// Compiles a GLSL shader */
- (GLuint)compileShader:(const char *)shaderName withType:(GLenum)shaderType;

// @name compileShaders */
// Compiles vertex and fragment shaders */
- (void)compileShaders;

// @name setupVBOs */
// Sets up VBOs */
- (void)setupVBOs;

// @name setupVBOs */
// Deletes VBOs */
- (void)deleteVBOs;

#pragma mark -
#pragma mark Wrappers
// Eminem lives here
// Guns don't kill people, wrappers do?
typedef struct GLTriangle3D          GLTriangle3D;
typedef struct GLVertex3D            GLVertex3D;
typedef struct GLVertex3DWithTexture GLVertex3DWithTexture;
typedef struct GLVertex3DWithOffset  GLVertex3DWithOffset;
typedef struct GLVertex3DWithUV      GLVertex3DWithUV;
typedef struct GLColour4f            GLColour4f;

-(void)addTriangles       :(GLTriangle3D *)triangles
                     count:(int)count
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addTriangleStrip   :(GLVertex3D *)vertices
                     count:(int)count
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addIndexedTriangles:(GLVertex3D *)vertices
                     count:(int)count
               withIndices:(GLushort *) __attribute__((cf_consumed)) indices
            withIndexCount:(int)indexCount
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
       animationParameters:(const SChartGLAnimationParams *)animationParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addLines           :(GLVertex3D *)vertices
                     count:(int)count
              withDrawMode:(GLenum)drawMode
                 withWidth:(float)width
           roundThickLines:(BOOL)round
     roundThickLineTexture:(int)texture
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addIndexedLines    :(GLVertex3D *)vertices
                     count:(int)count
               withIndices:(GLushort *)indices
            withIndexCount:(int)indexCount
              withDrawMode:(GLenum)drawMode
                 withWidth:(float)width
           roundThickLines:(BOOL)round
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
       animationParameters:(const SChartGLAnimationParams *)animationParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addLinesWithOffset :(GLVertex3DWithOffset *)vertices
                     count:(int)count
              withDrawMode:(GLenum)drawMode
                 withWidth:(float)width
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addPoints          :(GLVertex3DWithTexture *)points
                     count:(int)count
                withRadius:(float)radius
           withRadiusArray:(float*)radii
                    opaque:(BOOL)opaque
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addDynamicTriangles:(GLTriangle3D *)triangles
                     count:(int)count
                    opaque:(BOOL)opaque
         stencilParameters:(SChartGLStencilParams *)stencilParams
                  forLines:(BOOL)forLines
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch
            shouldFreeData:(BOOL)freeData;

-(void)addIndexedDynamicTriangles:(GLVertex3D *)vertices
                            count:(int)count
                      withIndices:(GLushort *)indices
                   withIndexCount:(int)indexCount
                           opaque:(BOOL)opaque
                stencilParameters:(SChartGLStencilParams *)stencilParams
                         forLines:(BOOL)forLines
                  withTranslation:(const SChartGLTranslation *)translation
           isLastInTransformBatch:(BOOL)endTransformBatch
                   shouldFreeData:(BOOL)freeData;

-(void)addIndexedOffsetTriangles:(GLVertex3DWithOffset *)vertices
                           count:(int)count
                     withIndices:(GLushort *)indices
                  withIndexCount:(int)indexCount
                          opaque:(BOOL)opaque
               stencilParameters:(SChartGLStencilParams *)stencilParams
                        forLines:(BOOL)forLines
                 withTranslation:(const SChartGLTranslation *)translation
          isLastInTransformBatch:(BOOL)endTransformBatch
                  shouldFreeData:(BOOL)freeData;

-(void)addPieSlice        :(GLVertex3DWithUV *)vertices
                     count:(int)count
               withIndices:(GLushort *)indices
            withIndexCount:(int)indexCount
            withFillColour:(GLColour4f *)fillColour
            withLineColour:(GLColour4f *)lineColour
             withLineWidth:(float)lineWidth
                 withAngle:(float)angle
          withDisplacement:(float)displacement
               withTexture:(int)texture
                     asPie:(BOOL)pieSlice;

- (GLuint)getPointTextureOfSize:(float)size isOpaque:(BOOL)opaque;

#pragma mark -
#pragma mark Drawing Methods

// @name beginRender */
// Clears the canvas and buffers and resets the buffers */
- (void)beginRenderWithPointRecalc:(BOOL)recalcPoints didReloadData:(BOOL)reloadedData isRadialChart:(BOOL)radialChart;

// @name endRender */
// Displays objects drawn since beginRender was last called, returns true if needs to redraw next frame */
- (BOOL)endRender;

// @name convertUIColorToGLColour4f */
// Converts a UIColor to a GLColour4f */
- (GLColour4f)convertUIColorToGLColour4f:(UIColor *) uiC;

@end

