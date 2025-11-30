<?php

namespace App\Controller;

use App\Entity\Media;
use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;

class UploadMediaController extends AbstractController
{
    public function __invoke(Request $request, EntityManagerInterface $em): JsonResponse
    {
        $uploadedFile = $request->files->get('file');
        if (!$uploadedFile) {
            throw new BadRequestHttpException('"file" is required');
        }

        $productId = $request->request->get('product');
        if ($productId) {
            $product = $em->getRepository(Product::class)->find($productId);
            if (!$product) {
                throw new BadRequestHttpException('Product not found');
            }
        } else {
            $product = null;
        }

        $media = new Media();
        $media->setFile($uploadedFile);
        $media->setProduct($product);

        $em->persist($media);
        $em->flush();

        return $this->json(['status' => 'success', 'media' => ['id' => $media->getId()]], 201);
    }
}
